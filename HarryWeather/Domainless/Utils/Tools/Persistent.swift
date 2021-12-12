//
//  Persistent.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import Foundation

enum PersistentKey: String, StorageTypeProtocol {
    case macAddress = "mac_addr"
    case deviceID   = "deviceID"
    case sessionID  = "session_id"
    case login      = "login"
    case greetings = "greetings"
    case needRegisterRetry = "needRegister"
    case needLoginRetry = "needLogin"
    case needSocmedLoginRetry = "needLoginSocmed"
    case accessToken = "accessToken"
    case oneSignalPlayerId = "oneSignalPlayerId"
    case firebasePushToken = "firebasePushToken"
    case bluedotZoneID = "bluedotZoneID"
    case bluedotFenceID = "bluedotFenceID"
    case bluedotBeaconID = "bluedotBeaconID"
    case tutorialPlaceShowed = "tutorialPlaceShowed"
    case preventTokenRefresh = "preventTokenRefresh"
    case lastPromoPopupShowed = "lastPromoPopupShowed"
    case lastOTPEmail = "lastOTPEmail"
    case lastOTPMsisdn = "lastOTPMSISDN"
    case registerCache = "registerCache"
    case otpRequestId = "otpRequestId"
    case standardShowcaseShowed = "standardShowcaseShowed"
    case loggedinShowcaseShowed = "loggedinShowcaseShowed"
    case latRegist = "latRegist"
    case lotRegist = "lotRegist"
    case app_opened_count = "app_opened_count"
    case installRef = "installRef"
    case cctvRoute = "isSeeAll"
    case familyNameApple = "familyNameApple"
    
    var storageType: PersistentStorageType {
        get {
            switch self {
            case .deviceID,.macAddress,.familyNameApple:
                return .keychain
            default:
                return .userDefault
            }
        }
    }
}

protocol StorageTypeProtocol {
    var storageType: PersistentStorageType { get }
}

enum PersistentStorageType {
    case userDefault
    case keychain
}

extension PersistentKey {
    private func getPrefix() -> String {
        return "prod_"
    }
    
    func modifiedKey() -> String {
        return getPrefix() + self.rawValue
    }
}

struct Persistent {
    static let shared = Persistent()
    private let keychain = KeychainSwift()
    
    func set(key: PersistentKey, value: String) {
        let storage = key.storageType
        
        if storage == .keychain {
            _ = keychain.set(value, forKey: key.modifiedKey())
        } else {
            UserDefaults.set(value, forKey: key.modifiedKey())
        }
    }
    
    func get(key: PersistentKey) -> String? {
        let storage = key.storageType
        
        if storage == .keychain {
            return keychain.get(key.modifiedKey())
        } else {
            return UserDefaults.get(key.modifiedKey())
        }
    }
    
    func delete(key: PersistentKey) {
        let storage = key.storageType
        
        if storage == .keychain {
            _ = keychain.delete(key.modifiedKey())
        } else {
            UserDefaults.delete(key.modifiedKey())
        }
    }
}
