//
//  Weather.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import ObjectMapper

struct Weather: Mappable{
    var dateTime: String?
    var epochDateTime: Int?
    var weatherIcon: Int?
    var iconPhrase: String?
    var hasPrecipitation: Bool?
    var isDaylight: Bool?
    var temperature: Temperature?
    var wind: Wind?
    
    var time: String{
        return dateTime?.getTime(format: "yyyy-MM-ddTHH:mm:ssZZZZZ") ?? ""
    }
    
    var date: String{
        return dateTime?.getDate(format: "yyyy-MM-ddTHH:mm:ssZZZZZ") ?? ""
    }
    
    var urlIcon: String{
        if let url = Constants.weatherUrlIcon{
            switch weatherIcon{
            case 1:
                return url + "01-s.png"
            case 2 :
                return url + "02-s.png"
            case 3 :
                return url + "03-s.png"
            case 4 :
                return url + "04-s.png"
            case 5 :
                return url + "05-s.png"
            case 6 :
                return url + "06-s.png"
            case 7 :
                return url + "07-s.png"
            case 8 :
                return url + "08-s.png"
            case 11 :
                return url + "11-s.png"
            case 12 :
                return url + "12-s.png"
            case 13 :
                return url + "13-s.png"
            case 14 :
                return url + "14-s.png"
            case 15 :
                return url + "15-s.png"
            case 16 :
                return url + "16-s.png"
            case 17 :
                return url + "17-s.png"
            case 18 :
                return url + "18-s.png"
            case 19 :
                return url + "19-s.png"
            case 20 :
                return url + "20-s.png"
            case 21 :
                return url + "21-s.png"
            case 22 :
                return url + "22-s.png"
            case 23 :
                return url + "23-s.png"
            case 24 :
                return url + "24-s.png"
            case 25 :
                return url + "25-s.png"
            case 26 :
                return url + "26-s.png"
            case 29 :
                return url + "29-s.png"
            case 30 :
                return url + "30-s.png"
            case 31 :
                return url + "31-s.png"
            case 32 :
                return url + "32-s.png"
            case 33 :
                return url + "33-s.png"
            case 34 :
                return url + "34-s.png"
            case 35 :
                return url + "35-s.png"
            case 36 :
                return url + "36-s.png"
            case 37 :
                return url + "37-s.png"
            case 38 :
                return url + "38-s.png"
            case 39 :
                return url + "39-s.png"
            case 40 :
                return url + "40-s.png"
            case 41 :
                return url + "41-s.png"
            case 42 :
                return url + "42-s.png"
            case 43 :
                return url + "43-s.png"
            case 44 :
                return url + "44-s.png"
            default:
                return url + "01-s.png"
            }
        }else{
            return "https://developer.accuweather.com/sites/default/files/01-s.png"
        }
        
        
        
    }
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        dateTime <- map["DateTime"]
        epochDateTime <- map["EpochDateTime"]
        weatherIcon <- map["WeatherIcon"]
        iconPhrase <- map["IconPhrase"]
        hasPrecipitation <- map["HasPrecipitation"]
        isDaylight <- map["IsDaylight"]
        temperature <- map["Temperature"]
        wind <- map["Wind"]
    }
}

struct Temperature: Mappable{
    var value: Float?
    var unit: String?
    var unitType: Int?
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        value <- map["Value"]
        unit <- map["Unit"]
        unitType <- map["UnitType"]
    }
}

struct Wind: Mappable{
    var speed: Speed?
    var direction: Direction?
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        speed <- map["Speed"]
        direction <- map["Direction"]
    }
}

struct Speed: Mappable{
    var value: Float?
    var unit: String?
    var unitType: Int?
    
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        value <- map["Value"]
        unit <- map["Unit"]
        unitType <- map["UnitType"]
    }
}

struct Direction: Mappable{
    var degree: Int?
    var direction: String?
    init?(map: Map){
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        degree <- map["Degrees"]
        direction <- map["Localized"]
    }
}
