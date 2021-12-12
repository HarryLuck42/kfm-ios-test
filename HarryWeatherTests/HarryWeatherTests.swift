//
//  HarryWeatherTests.swift
//  HarryWeatherTests
//
//  Created by Hariyanto Lukman on 12/12/21.
//

import XCTest
@testable import HarryWeather
import RxSwift

class HarryWeatherTests: XCTestCase {
    
    
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - Api Testing
    
    func testGetRegions(){
        viewModel.getRegions()
        viewModel.regions.asObservable().subscribe(onNext: { regions in
            if let results = regions{
                XCTAssertNotNil(regions)
                XCTAssertTrue(results.count > 0)
                XCTAssertEqual(results[0].id, "AFR")
                XCTAssertEqual(results[0].name, "Africa")
            }
        }).disposed(by: disposeBag)
    }
    
    func testGetCountries(){
        viewModel.getCountries(code: "ASI")
        viewModel.countries.asObservable().subscribe(onNext:{ countries in
            if let results = countries{
                XCTAssertNotNil(countries)
                XCTAssertTrue(results.count > 0)
                XCTAssertEqual(results[0].id, "AF")
                XCTAssertEqual(results[0].name, "Afghanistan")
            }
        }).disposed(by: disposeBag)
    }
    
    func testGetAreas(){
        viewModel.getAreas(code: "ID")
        viewModel.areas.asObservable().subscribe(onNext:{ areas in
            if let results = areas{
                XCTAssertNotNil(areas)
                XCTAssertTrue(results.count > 0)
                XCTAssertEqual(results[9].id, "JK")
                XCTAssertEqual(results[9].name, "Jakarta")
                XCTAssertEqual(results[9].level, 1)
                XCTAssertEqual(results[9].type, "Capital District")
                XCTAssertEqual(results[9].countryID, "ID")
            }
        }).disposed(by: disposeBag)
    }
    
    func testSearchWithIDCountry(){
        viewModel.searchCity(keyword: "Jakarta", countryId: "ID")
        viewModel.searchCity.asObservable().subscribe(onNext: { city in
            if let result = city{
                XCTAssertNotNil(city)
                XCTAssertEqual(result.key, "208971")
                XCTAssertEqual(result.type, "City")
                XCTAssertEqual(result.rank, 10)
                XCTAssertEqual(result.name, "Jakarta")
            }
        }).disposed(by: disposeBag)
    }
    
    func testSearchWithoutIDCountry(){
        viewModel.searchCity(keyword: "Jakarta")
        viewModel.searchCity.asObservable().subscribe(onNext: { city in
            if let result = city{
                XCTAssertNotNil(city)
                XCTAssertEqual(result.key, "208971")
                XCTAssertEqual(result.type, "City")
                XCTAssertEqual(result.rank, 10)
                XCTAssertEqual(result.name, "Jakarta")
            }
        }).disposed(by: disposeBag)
    }
    
    func testGetWeather(){
        viewModel.getWeather(key: "208971")
        viewModel.weather.asObservable().subscribe(onNext: { weather in
            if let result = weather{
                XCTAssertNotNil(weather)
                XCTAssertNotNil(result.dateTime)
                XCTAssertNotNil(result.epochDateTime)
                XCTAssertNotNil(result.weatherIcon)
                XCTAssertNotNil(result.iconPhrase)
                XCTAssertNotNil(result.hasPrecipitation)
                XCTAssertNotNil(result.isDaylight)
                XCTAssertNotNil(result.temperature)
                if let temperature = result.temperature{
                    XCTAssertNotNil(temperature.value)
                    XCTAssertNotNil(temperature.unit)
                }
                XCTAssertNotNil(result.wind)
                if let wind = result.wind{
                    XCTAssertNotNil(wind.direction)
                    if let direction = wind.direction{
                        XCTAssertNotNil(direction.degree)
                        XCTAssertNotNil(direction.direction)
                    }
                    XCTAssertNotNil(wind.speed)
                    if let speed = wind.speed{
                        XCTAssertNotNil(speed.value)
                        XCTAssertNotNil(speed.unit)
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Logic Testing
    let date = "2021-12-12T07:00:00+01:00"
    func testGetDateWeather(){
        let result = date.getDate(format: "yyyy-MM-ddTHH:mm:ssZZZZZ")
        XCTAssertEqual(result, "12 December 2021")
    }
    
    func testGetTimeWeather(){
        let result = date.getTime(format: "yyyy-MM-ddTHH:mm:ssZZZZZ")
        guard let date = Calendar.current.date(byAdding: .hour, value: -7, to: Date()) else { return  }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateEqual = dateFormatter.string(from: date)
        XCTAssertEqual(result, dateEqual)
        
    }
    
}
