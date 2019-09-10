# MqttCognitoWebSocektExample
This is sample projec for Mqtt Cognito WebSocekt Example with custom AWSCredentialsProvider

![MqttCognitoWebSocektExample-jpg](https://github.com/ali-cs/MqttCognitoWebSocektExample/blob/master/iotMqtt.jpg)

# Complete Tutorial

I have write a complete post for establishing a communication with AWS IoT MQTT using custom AWSCredentialsProvider in iOS applicaiton. [MQTT iOS Application Connection with custom Authentication in Congnito Mode](https://medium.com/@ali.cs/mqtt-iot-connection-with-custom-authentication-in-congnito-mode-in-ios-application-d0518c310070)


## Getting Started

First you need to add AWS SDK in your iOS project. It really easy using pod(s), pleae refer to [AWS Amplify documentation](https://aws-amplify.github.io/docs/). 

Change your keys in ```MqttConstants.swift``` class.

```
struct MqttConstants {
    static let endPoint          = "wss://a1pvqgswwsbwvy-ats.iot.eu-west-1.amazonaws.com/mqtt" // "wss:<IotEndpointATS>/mqtt
    
    static let IdentityPool      = "eu-west-1:9b8ca290-c620-452c-120c-77c6c442v6fd" // <IdentityPool>
    
    static let UserPool          = "<eu-west-1_bHTWQN1lI>" // <UserPool>
    
    static let kMQTTMKey         = "MQTTManager" // change to any key as your like :)
    
    static let mqttCognitoKey    = "cognito-idp.\(awsRegionString).amazonaws.com/\(UserPool)" // "cognito-idp.<REGION>.amazonaws.com/<UserPool>
    
    static let awsRegion         = AWSRegionType.EUWest1
    static let awsRegionString   = "eu-west-1"
    
    static let clientSecret      = "JWT Token" // place your client secret here
}
```


### Usage

In ViewController.swift class, mqtt connection is configured in method configureMQTTWebSocket(). Web Socket MQTT connectin is made in method connectUsingWebSocket() and mqttConnectionCallback will used as connection callback in which we are subscribing to a specific topic. 

mqttNotificationRecieved is call back when any MQTT connection is recieved and your can modify the publish() methdo to publish any data to AWS platform. 

```
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
```

## Authors

* **Ali Khan** - [ali-cs](https://github.com/ali-cs)


## License

This project is licensed under the MIT License - see the [LICENSE.MIT](LICENSE.MIT) file for details

## Acknowledgments

* Pull requests are warmly welcome as well.