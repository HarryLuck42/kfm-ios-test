//
//  Region.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 10/12/21.
//

import ObjectMapper

struct Region: Mappable{
    var id: String?
    var name: String?
    var level: Int?
    var type: String?
    var countryID: String?
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["ID"]
        name <- map["EnglishName"]
        level <- map["Level"]
        type <- map["EnglishType"]
        countryID <- map["CountryID"]
    }
    
}
