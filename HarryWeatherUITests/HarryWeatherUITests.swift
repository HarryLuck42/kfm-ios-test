//
//  HarryWeatherUITests.swift
//  HarryWeatherUITests
//
//  Created by Hariyanto Lukman on 12/12/21.
//

import XCTest

class HarryWeatherUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testGetWeatherBySelectCity(){
                
    }
}
