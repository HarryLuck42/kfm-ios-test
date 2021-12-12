//
//  MainInterceptor.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 10/11/21.
//

import Foundation
import RxSwift

struct MainInterceptor{
    
    static func getRegions() -> Observable<[Region]?> {
        return NetworkService.shared.connect(api: .getRegions, mappableType: [Region].self).map { results in
            return results
        }
    }
    
    static func getCountries(idRegion: String) -> Observable<[Region]?> {
        return NetworkService.shared.connect(api: .getCountries(regionCode: idRegion), mappableType: [Region].self).map { results in
            return results
        }
    }
    
    static func getAreas(idCountry: String) -> Observable<[Region]?> {
        return NetworkService.shared.connect(api: .getAreas(countryCode: idCountry), mappableType: [Region].self).map { results in
            return results
        }
    }
    
    static func searchCity(keyword: String, idCountry: String? = nil) -> Observable<City?> {
        if let code = idCountry{
            return NetworkService.shared.connect(api: .searchCity(city: keyword, countryCode: code), mappableType: [City].self).map { results in
                if results.count > 0{
                    return results[0]
                }else{
                    return nil
                }
            }
        }else{
            return NetworkService.shared.connect(api: .searchCityKey(keyword: keyword), mappableType: [City].self).map { results in
                if results.count > 0{
                    return results[0]
                }else{
                    return nil
                }
            }
        }
        
    }
    
    static func getWeather(key: String) -> Observable<Weather?>{
        return NetworkService.shared.connect(api: .getWeather(key: key), mappableType: [Weather].self).map { results in
            if results.count > 0{
                return results[0]
            }else{
                return nil
            }
        }
    }
}
