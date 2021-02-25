//
//  GM_Coding_ExerciseUITests.swift
//  GM Coding ExerciseUITests
//
//  Created by Derek on 2/21/21.
//

import XCTest

class GM_Coding_ExerciseUITests: XCTestCase {
    var app:XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
//testing to see if rotation and button stays same on iphone/ipad
    func test_rotationConstraints() throws {
        let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = XCUIDevice.shared.orientation.isPortrait
        
        app.textFields["Enter Artist Name"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Search Artist"]/*[[".buttons[\"Search Artist\"].staticTexts[\"Search Artist\"]",".buttons[\"Test\"].staticTexts[\"Search Artist\"]",".staticTexts[\"Search Artist\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIDevice.shared.orientation = .landscapeRight
        
        switch (isiPad,isPortrait) {
        case (true,true):
            app.textFields["Enter Artist Name"].tap()
            app/*@START_MENU_TOKEN@*/.staticTexts["Search Artist"]/*[[".buttons[\"Search Artist\"].staticTexts[\"Search Artist\"]",".buttons[\"Test\"].staticTexts[\"Search Artist\"]",".staticTexts[\"Search Artist\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
            XCUIDevice.shared.orientation = .landscapeRight
        case(true, false):
            break
        default:
            app/*@START_MENU_TOKEN@*/.staticTexts["Search Artist"]/*[[".buttons[\"Search Artist\"].staticTexts[\"Search Artist\"]",".buttons[\"Test\"].staticTexts[\"Search Artist\"]",".staticTexts[\"Search Artist\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            XCUIDevice.shared.orientation = .landscapeRight
        }
        XCTAssert(app.textFields["Enter Artist Name"].exists)
        
    }
}

