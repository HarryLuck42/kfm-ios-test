//
//  NetworkService.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import Foundation
import Alamofire
import Moya
import ObjectMapper
import RxSwift
import SystemConfiguration.CaptiveNetwork
import Localize_Swift
import NetworkExtension
import Toast_Swift

final class NetworkService {
    static let shared = NetworkService()
    
    static func getNetworkManager() -> Alamofire.SessionManager {
        return NetfoxService.sharedManager
    }
    
    func addRequestToQueueArray<T: Mappable>(api: ApiService, subject: ReplaySubject<[T]>, mappableType: [T].Type) {
        
            let networkManager = NetworkService.getNetworkManager()
            let provider = MoyaProvider<ApiService>(endpointClosure: api.endpointClosure, manager: networkManager)
            
            provider.request(api) { [weak self] result in
                switch result {
                case .success(let value):
                    do {
                        guard let jsonResponse = try value.mapJSON() as? [[String:Any]] else{
                            if let jsonResponse = try value.mapJSON() as? [String:Any] {
                                let code = value.statusCode
                                if code != 200 && code != 201{
                                    if  code == 401 {
                                        
                                        subject.onCompleted()
                                    } else if  code == 4010 {
                                        
                                    }
                                    self?.removeRunningProcess()
                                    if let message = jsonResponse["Message"] as? String{
                                        subject.onError(ApiError.middlewareError(code: code, message: message))
                                    }
                                    
                                    return
                                }
                            }
                            
                            return
                        }
                        
                        let code = value.statusCode
                        
                        if code != 200 && code != 201{
                            if  code == 401 {
                                
                                subject.onCompleted()
                            } else if  code == 4010 {
                                
                            }
                            self?.removeRunningProcess()
                            return
                        }
                        
                        
                        
                        let data = Mapper<T>().mapArray(JSONArray: jsonResponse)
                        subject.onNext(data)
                        subject.onCompleted()
                        
                        
                        
                        
                        self?.removeRunningProcess()
                    } catch {
                        subject.onError(ApiError.invalidJSONError(code: 0))
                        self?.removeRunningProcess()
                    }
                case .failure:
                    subject.onError(ApiError.connectionError(code: 0))
                    self?.removeRunningProcess()
                    print("error api \(api.path)")
                }
            }
    }
    
    func addRequestToQueue<T: Mappable>(api: ApiService, subject: ReplaySubject<T>, mappableType: T.Type) {
        let networkManager = NetworkService.getNetworkManager()
        let provider = MoyaProvider<ApiService>(endpointClosure: api.endpointClosure, manager: networkManager)
        
        provider.request(api) { [weak self] result in
            switch result {
            case .success(let value):
                do {
                    guard let jsonResponse = try value.mapJSON() as? [String: Any],
                          let code = value.statusCode as? Int  else {
                              subject.onError(ApiError.invalidJSONError(code: 0))
                              self?.removeRunningProcess()
                              return
                          }
                    if code != 200 && code != 201{
                        if  code == 401 {
                            
                            subject.onCompleted()
                        } else if  code == 4010 {
                            let map = Map(mappingType: .fromJSON, JSON: jsonResponse)
                            if let obj = mappableType.init(map: map) {
                                subject.onNext(obj)
                            }
                        } else if let body = jsonResponse["error_localized"] as? [String: String] {
                            let key = Localize.currentLanguage()
                            let message = body[key]
                            subject.onError(ApiError.middlewareError(code: jsonResponse["code"] as? Int ?? 0, message: message))
                            
                        }else if let code = jsonResponse["code"] as? Int, code == 422 {
                            let messageData = jsonResponse["data"] as? [String:Any]
                            let messageCode = messageData? ["code"] as? [String]
                            subject.onError(ApiError.middlewareError(code: jsonResponse["code"] as? Int ?? 0, message: (messageCode?[0])?.localized()))
                        }else {
                            subject.onError(ApiError.middlewareError(code: jsonResponse["code"] as? Int ?? 0, message: (jsonResponse["message"] as? String)?.localized()))
                            
                        }
                        self?.removeRunningProcess()
                        return
                    }
                    
                    let map = Map(mappingType: .fromJSON, JSON: jsonResponse)
                    
                    
                    guard let responseObject = mappableType.init(map: map) else {
                        subject.onError(ApiError.failedMappingError(code: 0))
                        self?.removeRunningProcess()
                        return
                    }
                    subject.onNext(responseObject)
                    subject.onCompleted()
                    
                    
                    
                    
                    
                    self?.removeRunningProcess()
                } catch {
                    subject.onError(ApiError.invalidJSONError(code: 0))
                    self?.removeRunningProcess()
                }
            case .failure:
                subject.onError(ApiError.connectionError(code: 0))
                self?.removeRunningProcess()
                print("error api \(api.path)")
            }
        }
    }
    
    var subjectCache = [Any]()
    var processCache = [() -> Void]()
    var isRunning = false
    
    func removeRunningProcess() {
        _ = subjectCache.remove(at: 0)
        _ = processCache.remove(at: 0)
        isRunning = false
        runTheFirstIfPossible()
    }
    
    func runTheFirstIfPossible() {
        if isRunning || processCache.count < 1 { return }
        isRunning = true
        processCache.first?()
    }
    
    func connect<T: Mappable>(api: ApiService, mappableType: T.Type) -> Observable<T> {
        let subject = ReplaySubject<T>.createUnbounded()
        subjectCache.append(subject)
        processCache.append {
            [weak self] in
            self?.addRequestToQueue(api: api, subject: subject, mappableType: mappableType)
        }
        runTheFirstIfPossible()
        return subject
    }
    
    func connect<T: Mappable>(api: ApiService, mappableType: [T].Type) -> Observable<[T]> {
        let subject = ReplaySubject<[T]>.createUnbounded()
        subjectCache.append(subject)
        processCache.append {
            [weak self] in
            self?.addRequestToQueueArray(api: api, subject: subject, mappableType: mappableType)
        }
        runTheFirstIfPossible()
        return subject
    }
}

extension NetworkService {
    static func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        
        return address?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    static func currentBSSID() -> String {
        for one in currentSSIDs() {
            if !one.bssid.isEmpty {
                return one.bssid
            }
        }
        
        return ""
    }
    
    typealias SSIDResult = (ssid: String, bssid: String)
    
    static func currentSSIDs() -> [SSIDResult] {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        return interfaceNames.flatMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            
            var ssid = ""
            var bssid = ""
            
            if let thessid = info[kCNNetworkInfoKeySSID as String] as? String {
                ssid = thessid
            }
            if let thebssid = info[kCNNetworkInfoKeyBSSID as String] as? String {
                bssid = thebssid
            }
            return (ssid: ssid, bssid: bssid)
        }
    }
}
