//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import XCTest
import MapKit
@testable import Restaurants

class RestaurantsTests: XCTestCase {
    var restaurantMapViewModel:RestaurantMapViewModel?

    let restaurantMapView = RestaurantMapViewController()
    var restaurantArray:[RestaurantModel]?
    
    private var restuarantListExpectation: XCTestExpectation?

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restaurantMapView.loadViewIfNeeded()
        restaurantMapViewModel = restaurantMapView.viewModel
        restaurantMapViewModel?.delegate = self
        
        if let restaurantList = restaurantMapViewModel?.restaurantList{
            restaurantArray = restaurantList
            
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testIfMapViewExists() {
        restaurantMapView.loadViewIfNeeded()
        XCTAssertNotNil(restaurantMapView.mapView)
    }
    
    func testMapViewHasCorrectAnnotationsCount() {
        restaurantMapView.loadViewIfNeeded()
        XCTAssertEqual(restaurantMapView.mapView.annotations.count, restaurantArray?.count)
    }
    
    func testEachAnnotationHasCorrectParameters() {
        restaurantMapView.loadViewIfNeeded()
        
        restuarantListExpectation = expectation(description: "Check if data has been fetched")
        restuarantListExpectation?.expectedFulfillmentCount = 1
        
        let rect = MKMapRect(x : 189329279.5269284, y : 120144123.78245166, width : 19603.886118233204, height : 31820.800599217415)
        restaurantMapViewModel?.getRestaurantList(mapRect: rect)
        
         waitForExpectations(timeout: 20, handler: nil)

        if let restaurantList = restaurantMapViewModel?.restaurantList{
            for restaurant in restaurantList {
                if let annotation:RestaurantMapAnnotation = restaurantMapView.mapView.annotations.filter({$0.title == restaurant.name}).first as? RestaurantMapAnnotation {
                    XCTAssertEqual(annotation.title, String(restaurant.name ?? ""), "Restaurant's name match")
                    XCTAssertEqual(annotation.coordinate.latitude, restaurant.location?.lat, "Restaurant's latitude match")
                    XCTAssertEqual(annotation.coordinate.longitude, restaurant.location?.lng, "Restaurant's longitude match")
                }
                else{
                    XCTFail()
                }
            }
        }
        else{
            XCTFail()
        }
    }
    
    func testNavigationBarHasTitle() {
        XCTAssertEqual(restaurantMapView.title, "Restaurants")
        
    }
}

extension RestaurantsTests: RestaurantMapDataUpdater{
    func reloadMapView() {
        DispatchQueue.main.async() { () -> Void in
            self.restaurantMapView.mapView.removeAnnotations(self.restaurantMapView.mapView.annotations)
            self.restaurantMapView.mapView.addAnnotations((self.restaurantMapViewModel?.getAnnotations())!)
            self.restuarantListExpectation?.fulfill()

        }
    }
    
    func setError(error: APIError) {
        XCTFail()
    }
    
    func showDetail(restaurant: RestaurantModel) {
        print("show detail")
    }
    
    
}

class DetailViewTests: XCTestCase {
    
    let validJSONString = """
 {\"id\":\"505834e3e4b05491a845245b\",\"name\":\"classic Veg Restaurant\",\"location\":{\"lat\":19.024586378764475,\"lng\":72.85628173015172,\"labeledLatLngs\":[{\"label\":\"display\",\"lat\":19.024586378764475,\"lng\":72.85628173015172}],\"cc\":\"IN\",\"country\":\"India\",\"formattedAddress\":[\"India\"]},\"categories\":[{\"id\":\"4bf58dd8d48988d1d3941735\",\"name\":\"Vegetarian \\/ Vegan Restaurant\",\"pluralName\":\"Vegetarian \\/ Vegan Restaurants\",\"shortName\":\"Vegetarian \\/ Vegan\",\"icon\":{\"prefix\":\"https:\\/\\/ss3.4sqi.net\\/img\\/categories_v2\\/food\\/vegetarian_\",\"suffix\":\".png\"},\"primary\":true}],\"referralId\":\"v-1571227381\",\"hasPerk\":false}
 """
    
    var restaurantDetailViewModel:RestaurantDetailViewModel?
    
    let restaurantDetailView = RestaurantDetailViewController()
    var restaurantObj:RestaurantModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restaurantDetailView.loadViewIfNeeded()
        
        let jsonData = validJSONString.data(using: .utf8)!
        let tempRestaurant = try! JSONDecoder().decode(RestaurantModel.self, from: jsonData)
        
        restaurantDetailView.setRestaurant(restaurantObj: tempRestaurant)
        restaurantDetailViewModel = restaurantDetailView.viewModel
        
        if let restaurant = restaurantDetailViewModel?.restaurant{
            restaurantObj = restaurant
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfDetailLabelExists() {
        XCTAssertNotNil(restaurantDetailView.detailLabel)
    }
    
    func testDetailViewHasCorrectAnnotationsCount() {
        XCTAssertTrue(restaurantDetailView.detailLabel.text!.count > 0, "Detail text is not nil")
    }
    
    func testDetailText() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        restaurantDetailView.setRestaurantDetail()
        XCTAssertEqual(restaurantDetailView.detailLabel.text, restaurantDetailViewModel?.getRestaurantDetailString())
        
    }
    
    func testNavigationBarHasTitle() {
        XCTAssertEqual(restaurantDetailView.title, restaurantDetailViewModel?.restaurant?.name)
        
    }
    
}

class DetailViewInValidTests:XCTestCase{
    let emptyAddressCategoryJSONString = """
 {\"id\":\"505834e3e4b05491a845245b\",\"name\":\"\",\"location\":{\"lat\":19.024586378764475,\"lng\":72.85628173015172,\"labeledLatLngs\":[{\"label\":\"display\",\"lat\":19.024586378764475,\"lng\":72.85628173015172}],\"cc\":\"IN\",\"country\":\"India\",\"formattedAddress\":[]},\"categories\":[],\"referralId\":\"v-1571227381\",\"hasPerk\":false}
 """
    
    var restaurantDetailViewModel:RestaurantDetailViewModel?
    
    let restaurantDetailView = RestaurantDetailViewController()
    var restaurantObj:RestaurantModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let jsonData = emptyAddressCategoryJSONString.data(using: .utf8)!
        let tempRestaurant = try! JSONDecoder().decode(RestaurantModel.self, from: jsonData)
        
        restaurantDetailView.setRestaurant(restaurantObj: tempRestaurant)
        restaurantDetailViewModel = restaurantDetailView.viewModel
        
        if let restaurant = restaurantDetailViewModel?.restaurant{
            restaurantObj = restaurant
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDetailTextNoText() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        restaurantDetailView.loadViewIfNeeded()
        XCTAssertEqual(restaurantDetailView.detailLabel.text, "Address: NA\nCategory: NA")
        
    }
    
    func testNavigationBarNoTitle() {
        XCTAssertEqual(restaurantDetailView.title, "")
        
    }
}
