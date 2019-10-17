//
//  NetworkTests.swift
//  RestaurantsTests
//
//  Created by Venugopalan, Vimal on 16/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import XCTest
@testable import Restaurants

struct UnsuccessfulResponseRequest: BaseRequest {
    
    var urlString: String {
        return "https://api.foursquare.com/v2/venues/search?ll=40.74224,-73.99386&client_id=LRB1YHLYKJXM1A4SY0ONCGNNYBDER5VRIWJGU3GFBHVOIRJ4&client_secret=FJGGHUD5QQ40ELOSYUUMYUE3ZGKW1THMF1SD32VDZFBVDMFE"
    }
}

struct RequestFailedRequest: BaseRequest {
    
    var urlString: String {
        return "www.google.com"
    }
}

class NetworkTests: XCTestCase {
    
    let restaurantListGetManager = RestaurantListGetManager()
    let imageDownloadManager = ImageDownloadManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// Testing Weather API with an invalid url for unsuccessful response
    func testWeatherListResponseUnsuccessful() {
        let expected = expectation(description: "Check unsucessful response")
        restaurantListGetManager.getRestaurantList(from: UnsuccessfulResponseRequest(), completion: {
            result in
            switch result {
            case .success( _):
                XCTFail()
            case .failure(let error):
                expected.fulfill()
                XCTAssertEqual(error, APIError.responseUnsuccessful)
                XCTAssertEqual(error.message, "Response Unsuccessful")
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    /// Testing Weather API with an invalid url for failed response
    func testWeatherListResponseRequestFailed() {
        let expected = expectation(description: "Check request failed response")
        restaurantListGetManager.getRestaurantList(from: RequestFailedRequest(), completion: {
            result in
            switch result {
            case .success( _):
                XCTFail()
            case .failure(let error):
                expected.fulfill()
                XCTAssertEqual(error, APIError.requestFailed)
                XCTAssertEqual(error.message, "Request Failed")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Testing Weather API with an valid url for successful response
    func testWeatherListSuccessfulResponse() {
        let expected = expectation(description: "Check response is successful")
        let northEast = "19.026452072221126,72.86116440000012"
        let southWest = "19.008776857936542,72.85116440000013"
        restaurantListGetManager.getRestaurantList(from: RestaurantListGetRequest(northEast: northEast, southWest: southWest), completion: {
            result in
            switch result {
            case .success(let weatherResponseModel):
                if weatherResponseModel != nil{
                    expected.fulfill()
                }
            case .failure( _):
                XCTFail()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    /// Testing Weather API with an valid image for successful download
    func testImageDownloadSuccessful() {
        let expected = expectation(description: "Check download is successful")
        let imageDownloadRequest = ImageDownloadRequest(imagePath: "https://ss3.4sqi.net/img/categories_v2/food/default_bg_64.png")
        imageDownloadManager.getImageFile(from: imageDownloadRequest, completion: ({ result in
            switch result {
            case .success( _):
                expected.fulfill()
            case .failure( _):
                XCTFail()
            }
        }))
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    /// Testing Weather API with an invalid url for download error
    func testImageDownloadError() {
        let expected = expectation(description: "Check download is unsuccessful")
        imageDownloadManager.getImageFile(from: RequestFailedRequest(), completion: ({ result in
            switch result {
            case .success( _):
                XCTFail()
            case .failure( _):
                expected.fulfill()
            }
        }))
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}

class CacheManagerTests: XCTestCase {
    /// Testing cache manager with an invalid url
    
    func testCacheManagerFailedRequest(){
        let expected = expectation(description: "Check cache returns nil data")
        
        if CacheManager.shared().object(forKey: "abc") == nil {
            expected.fulfill()
        }
        else{
            XCTFail()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
