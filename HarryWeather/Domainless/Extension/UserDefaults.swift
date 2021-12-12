//
//  UserDefaults.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import Foundation

extension UserDefaults {
  static func get(_ key: String) -> String? {
    let val = UserDefaults.standard.value(forKey: key)
    if let v = val as? String {
      return Encryption.decrypt(param:v)
    }
    
    return nil
  }
  
  static func delete(_ key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  static func set(_ val: String, forKey key: String) {
    let v = Encryption.encrypt(param: val)
    UserDefaults.standard.set(v, forKey: key)
    UserDefaults.standard.synchronize()
  }
}
