//
//  RestaurantsUITests.swift
//  RestaurantsUITests
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import XCTest

class RestaurantsUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchEnvironment = ["animations" : "0"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test app flow
    func testZoomReload() {
        let expected = expectation(description: "Annotation View tapped")
        
        if app.otherElements["RestaurantAnnotation_0"].waitForExistence(timeout: 10){
            let restaurantannotation0Element = app.otherElements["RestaurantAnnotation_0"]
            sleep(2)
            restaurantannotation0Element.doubleTap()
            sleep(2)
            expected.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        
    }
    
    func testNearMe(){
        if app.navigationBars["Restaurants"].waitForExistence(timeout: 5){
            let navigationBarButton = app.navigationBars["Restaurants"].buttons["Near Me"]
            navigationBarButton.tap()
        }
    }
    
    /// Test app flow
    func testAppFlow() {
        let expected = expectation(description: "Annotation View tapped")
        
        if app.otherElements["RestaurantAnnotation_0"].waitForExistence(timeout: 10){
            let restaurantannotation0Element = app.otherElements["RestaurantAnnotation_0"]
            restaurantannotation0Element.tap()
            sleep(2)
            restaurantannotation0Element.tap()
            sleep(2)
            
            tapCoordinate(at: Double(restaurantannotation0Element.frame.minX), and: Double(restaurantannotation0Element.frame.minY - 50))
            
            sleep(3)
            app.navigationBars.firstMatch.buttons["Restaurants"].tap()
            
            expected.fulfill()
        }
       
        waitForExpectations(timeout: 10, handler: nil)

    }
    
    /// test background reload
    func testBackGroundReload() {
        sleep(5)
        //press home button
        XCUIDevice.shared.press(.home)
        //relaunch app from background
        app.activate()
        sleep(5)
    }
}

extension RestaurantsUITests{
    //tap at coordinate method
    func tapCoordinate(at xCoordinate: Double, and yCoordinate: Double) {
        let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }
}
