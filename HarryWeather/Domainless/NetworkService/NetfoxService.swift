//
//  NetfoxService.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 11/11/21.
//

import Foundation
import netfox
import Alamofire


final class NetfoxService: Alamofire.SessionManager {
  static let sharedManager: NetfoxService = {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
//    configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 40
    configuration.timeoutIntervalForResource = 40
    let manager = NetfoxService(configuration: configuration)
    return manager
  }()
}

