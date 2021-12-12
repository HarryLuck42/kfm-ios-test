//
//  City.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import ObjectMapper

struct City: Mappable{
    var key: String?
    var type: String?
    var rank: Int?
    var name: String?
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        key <- map["Key"]
        type <- map["Type"]
        rank <- map["Rank"]
        name <- map["EnglishName"]
    }
    
}
