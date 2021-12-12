//
//  HarryWeatherUITestsLaunchTests.swift
//  HarryWeatherUITests
//
//  Created by Hariyanto Lukman on 12/12/21.
//

import XCTest

class HarryWeatherUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()


        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testSearchByKeyword(){
        let app = XCUIApplication()
        app.launch()
                
    }
}
