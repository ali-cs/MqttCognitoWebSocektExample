//
//  ViewController.swift
//  MqttCognitoWebSocektExample
//
//  Created by Ali Khan on 02/Sep/2019.
//  Copyright © 2019 Ali Khan. All rights reserved.
//

import UIKit
import AWSIoT

class ViewController: UIViewController {
    
    
    private var mqttConnection           : AWSIoTDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureMQTTWebSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK:- Helper Methods
    
    func configureMQTTWebSocket() {
        
        let iotEndPoint         = AWSEndpoint(urlString: MqttConstants.endPoint)
        
        let loginAuth           = CredentialIdentityAuthenticationProvider(regionType: MqttConstants.awsRegion, identityPoolId: MqttConstants.IdentityPool, useEnhancedFlow: true, identityProviderManager: nil)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: MqttConstants.awsRegion, identityProvider: loginAuth)
        
        if let serviceConfiguration = AWSServiceConfiguration(region: MqttConstants.awsRegion, endpoint: iotEndPoint, credentialsProvider: credentialsProvider) {
            
            AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
            
            AWSIoTDataManager.register(with: serviceConfiguration, forKey: MqttConstants.kMQTTMKey)
            
            mqttConnection = AWSIoTDataManager(forKey: MqttConstants.kMQTTMKey)
            
            credentialsProvider.getIdentityId().continueWith(block: aWSCognitoCredentialsProviderHanlder)
        }
        
    }
    
    func aWSCognitoCredentialsProviderHanlder(task: AWSTask<NSString>) -> Any? {
        if let error = task.error as NSError? {
            print("Failed to get client ID => \(error)")
            return nil  // Required by AWSTask closure
        }
        
        if let clientId = task.result as String? {
            print("Got client ID => \(clientId)")
            connectUsingWebSocket(clientId: clientId)
        }
        
        return nil
    }
    
    func stop() {
        mqttConnection?.disconnect()
    }
    
    func connectUsingWebSocket(clientId: String) {
        
        let resposne = mqttConnection?.connectUsingWebSocket(withClientId: clientId, cleanSession: true, statusCallback: mqttConnectionCallback)
        
        print("connectUsingWebSocket resposne", resposne ?? false)
    }
    
    func mqttConnectionCallback( _ status: AWSIoTMQTTStatus ) {
        
        // AWS IoT connection will not be callback if the connection value are not correct. Set your AWS connection values in 'MqttConstants.swift', HINT: Check console for AWSError/ Warning
        
        
        switch(status) {
            
        case .connecting:
            print("Connecting...")
            
        case .connected:
            print("MQTT Connected")
            subscribe()
            
        case .disconnected:
            print("Disconnected")
            
        case .connectionRefused:
            print("Connection Refused")
            
        case .connectionError:
            print("Connection Error")
            
        case .protocolError:
            print("Protocol Error")
            
        default:
            print("Unknown State")
        }
        
    }
    
    private func subscribe() {
        let subscribeTopic  = "<subscribe topic>"
        
        let response        = mqttConnection?.subscribe(toTopic: subscribeTopic, qoS: AWSIoTMQTTQoS.messageDeliveryAttemptedAtLeastOnce, messageCallback: mqttNotificationRecieved) ?? false
        
        print("mqtt subscribe toTopic -> ", subscribeTopic, " , response -> ", response)
    }
    
    private func mqttNotificationRecieved(payload: Data) {
        
        if let jsonString = payload.prettyJSONString() {
            print("mqttNotificationRecieved -> \(jsonString)")
        }
        
    }
    
    private func publish() {
        
        let publishTopic             = "<subscribe topic>"
        
        let publishDataDictionary    = ["id":"000006012", "value1": 1, "value2": 0] as [String : Any]
        
        do {
            let publishDats = try JSONSerialization.data(withJSONObject: publishDataDictionary, options: [])
            let response = mqttConnection?.publishData(publishDats, onTopic: publishTopic, qoS: AWSIoTMQTTQoS.messageDeliveryAttemptedAtLeastOnce) ?? false
            
            //let response = mqttConnection?.publishString(publishDataDictionary.description, onTopic: publishTopic, qoS: AWSIoTMQTTQoS.messageDeliveryAttemptedAtLeastOnce)  ?? false

            print("mqtt publish toTopic -> ", publishTopic, " , response -> ", response)
        }
        catch {
            print("error converting dictionary into Data")
        }
        
    }
    
}

