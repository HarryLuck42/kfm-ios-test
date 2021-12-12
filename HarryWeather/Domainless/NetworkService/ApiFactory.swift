//
//  ApiFactory.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import Foundation
import Moya
import Localize_Swift

let apiBaseURL = URL(string: Constants.urlBaseWeatherUrl ?? "")!
let apiToken = Constants.apiTokenWeather

enum ApiService{
    case getRegions
    case getCountries(regionCode: String)
    case getAreas(countryCode: String)
    case searchCity(city: String, countryCode: String)
    case searchCityKey(keyword: String)
    case getWeather(key: String)
}

extension ApiService: TargetType{
    var baseURL: URL {
        return apiBaseURL
    }
    
    var path: String {
        switch self {
        case .getRegions:
            return "locations/v1/regions"
        case .getCountries(let regionCode):
            return "locations/v1/countries/\(regionCode)"
        case .getAreas(let countryCode):
            return "locations/v1/adminareas/\(countryCode)"
        case .searchCity(_, let countryCode):
            return "locations/v1/cities/\(countryCode)/search"
        case .searchCityKey:
            return "locations/v1/cities/search"
        case .getWeather(let key):
            return "forecasts/v1/hourly/1hour/\(key)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRegions,
                .getCountries,
                .getAreas,
                .searchCity,
                .searchCityKey,
                .getWeather:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRegions, .getCountries, .getAreas:
            let params: [String: Any] = ["apikey" : apiToken ?? "",
                                         "language" : "en-us"]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        case .searchCity(let city, _):
            let params: [String: Any] = ["apikey" : apiToken ?? "",
                                         "q" : city,
                                         "language" : "en-us"]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        case .searchCityKey(let keyword):
            let params: [String: Any] = ["apikey" : apiToken ?? "",
                                         "q" : keyword,
                                         "language" : "en-us"]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        case .getWeather:
            let params: [String: Any] = ["apikey" : apiToken ?? "",
                                         "details": "true",
                                         "language" : "en-us"]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        
        
        return getHeaders()
    }
    
    fileprivate func getHeaders() -> [String: String] {
        let date = Date()
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        let dateSt:String = String(dateStamp)
        let timeZone = TimeZone.current
        let timeStr : String = timeZone.identifier
        let header = [
            "X-Device-Type": "iOS",
            "X-Accept-Language": Localize.currentLanguage(),
            "X-Timestamp" : dateSt,
            "X-Device-Timezone" : timeStr
        ]
        
        return header
    }
    
    var endpointClosure: (ApiService) -> Endpoint {
        return { _ in
            return MoyaProvider.defaultEndpointMapping(for: self).adding(newHTTPHeaderFields: self.headers!)
        }
    }
    
}

