//
//  Constraint.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import UIKit
struct Constants {
    
    // MARK: Weather Base URL Api
    static let urlBaseWeatherUrl = Bundle.main.infoDictionary!["Weather Url"] as? String
    
    // MARK: Weather Base Api Token
    static let apiTokenWeather = Bundle.main.infoDictionary!["Weather Token"] as? String
    
    // MARK: Weather URL Icon
    static let weatherUrlIcon = Bundle.main.infoDictionary!["Weather Icon"] as? String
    
    // MARK: UUID Device Identifier
    static var deviceIdentifier : String {
        get {
            if let uid = Persistent.shared.get(key: .deviceID) {
                return uid
            } else {
                if let uid = UIDevice.current.identifierForVendor?.uuidString {
                    Persistent.shared.set(key: .deviceID, value: uid)
                    return uid
                }
                return "application_generated_device_id"
            }
            
        }
    }
    
    static let language = "en-US"
}
