//
//  AppConstants.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

/// Network URLs
struct NetworkData {
    static let kBaseURL = "https://api.foursquare.com/v2/"
    static let kFoodCategoryEndPoint = "venues/search?&intent=browse&query=restaurant"
    static let kClientIdEndPoint = "client_id=LRB1YHLYKJXM1A4SY0ONCGNNYBDER5VRIWJGU3GFBHVOIRJ4"

    static let kClientSecretEndPoint = "client_secret=FJGGHUD5QQ40ELOSYUUMYUE3ZGKW1THMF1SD32VDZFBVDMFE"
    
    static let kNorthEastEndPoint = "ne="
    static let kSouthWestEndPoint = "sw="
    static let kVersion = "v="


}


/// Constant String used in the app
struct AppIdentifierStrings {
    static let kShowRestaurantDetailSegueIdentifier = "showRestaurantDetail"
    static let kRestaurantAnnotationReuseIdentifier = "RestaurantAnnotation"
}

/// API related errors
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case noInternetError
    
    var message: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .noInternetError: return "No Internet Connection"
        }
    }
}
