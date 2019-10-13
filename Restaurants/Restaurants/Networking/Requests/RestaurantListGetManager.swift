//
//  RestaurantListGetManager.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class RestaurantListGetRequest: BaseRequest {
    
    var urlString: String = ""
    
    //https://api.foursquare.com/v2/venues/search?ll=40.74224,-73.99386&client_id=LRB1YHLYKJXM1A4SY0ONCGNNYBDER5VRIWJGU3GFBHVOIRJ4&client_secret=FJGGHUD5QQ40ELOSYUUMYUE3ZGKW1THMF1SD32VDZFBVDMFE&v=20191012

    init(northEast: String, southWest: String){
        urlString = NetworkData.kBaseURL + NetworkData.kFoodCategoryEndPoint + "&" + NetworkData.kClientIdEndPoint + "&" + NetworkData.kClientSecretEndPoint + "&" + NetworkData.kNorthEastEndPoint + northEast + "&" + NetworkData.kSouthWestEndPoint + southWest + "&v=20191012"
    }
}

class RestaurantListGetManager: NetworkManager {
    var session: URLSession
    
    
    /// Init function with URLSession configuration
    ///
    /// - Parameter configuration: URLSessionConfiguration
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Get Restaurant List
    ///
    /// - Parameters:
    ///   - request: BaseRequest object to check negative cases, should be restaurantListGetRequest
    ///   - completion: Result consisting of the restaurantDataModel Object or APIError
    func getRestaurantList(from request: BaseRequest, completion: @escaping (Result<RestaurantResponseModel?, APIError>) -> Void) {
        if let requestObj = request.request{
            fetch(with: requestObj, decode: { json -> RestaurantResponseModel? in
                guard let restaurantListModelResult = json as? RestaurantResponseModel else { return  nil }
                return restaurantListModelResult
            }, completion: completion)
        }
        else{
            completion(Result.failure(.requestFailed))
        }
    }
}
