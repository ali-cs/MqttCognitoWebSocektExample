//
//  CredentialIdentityAuthenticationProvider.swift
//  MqttCognitoWebSocektExample
//
//  Created by Ali Khan on 02/Sep/2019.
//  Copyright © 2019 Ali Khan. All rights reserved.
//

import Foundation
import AWSCore

/*
 * Use the token method to communicate with your backend to get an
 * identityId and token.
 */

class CredentialIdentityAuthenticationProvider : AWSCognitoCredentialsProviderHelper {
    
    override func token() -> AWSTask<NSString> {
        //Write code to call your backend:
        //pass username/password to backend or some sort of token to authenticate user, if successful,
        //from backend call getOpenIdTokenForDeveloperIdentity with logins map containing "your.provider.name":"enduser.username"
        //return the identity id and token to client
        //You can use AWSTaskCompletionSource to do this asynchronously
        
        // Set the identity id and return the token
        
        self.identityId     = MqttConstants.mqttCognitoKey
        
        let value           = MqttConstants.clientSecret 
        
        return AWSTask(result: value as NSString)
    }
    
    override func logins() -> AWSTask<NSDictionary> {
        let key             = MqttConstants.mqttCognitoKey
        let value           = MqttConstants.clientSecret
        
        let dictionary      = NSDictionary(dictionary: [key:value])
        
        return AWSTask(result: dictionary)
    }
}
