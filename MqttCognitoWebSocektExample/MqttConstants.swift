//
//  Constants.swift
//  MqttCognitoWebSocektExample
//
//  Created by Ali Khan on 02/Sep/2019.
//  Copyright © 2019 Ali Khan. All rights reserved.
//

// Please update your AWS IoT keys here in order to perform connection suucesfully. Beow keys are only for sample and will not be connect with AWS

import Foundation
import AWSIoT

struct MqttConstants {
    static let endPoint          = "wss://a1pvqgswvgbwuy-ats.iot.eu-west-1.amazonaws.com/mqtt" // "wss:<IotEndpointATS>/mqtt
    
    static let IdentityPool      = "eu-west-1:9b8ab290-c620-412c-190c-27c6b443v3fd" // <IdentityPool>
    
    static let UserPool          = "<eu-west-1_cHTQQN1lI>" // <UserPool>
    
    static let kMQTTMKey         = "MQTTManager" // change to any key as your like :)
    
    static let mqttCognitoKey    = "cognito-idp.\(awsRegionString).amazonaws.com/\(UserPool)" // "cognito-idp.<REGION>.amazonaws.com/<UserPool>
    
    static let awsRegion         = AWSRegionType.EUWest1
    static let awsRegionString   = "eu-west-1"
    
    static let clientSecret      = "JWT Token" // place your client secret here
}

