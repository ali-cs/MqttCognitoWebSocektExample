//
//  DataExtension.swift
//  MqttCognitoWebSocektExample
//
//  Created by Ali Khan on 28/08/2019.
//  Copyright © 2019 Ali Khan. All rights reserved.
//

import Foundation

extension Data {
    
    func prettyJSONString() -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(bytes: prettyPrintedData, encoding: String.Encoding.utf8) ?? nil
            }
        }
        return nil
    }
    
    func JSON() -> [String : Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String : Any] {
            return json
        }
        return nil
    }
}
