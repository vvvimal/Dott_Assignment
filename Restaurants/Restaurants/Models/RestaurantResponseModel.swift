//
//  RestaurantResponseModel.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

struct RestaurantResponseModel: Decodable {
    let meta: MetaModel?
    let response:ResponseModel
}

struct MetaModel:Decodable{
    let code: Int?
    let requestId: String?
}

struct ResponseModel:Decodable{
    let venues:[RestaurantModel]
    let confident:Bool?
}

struct RestaurantModel:Decodable {
    let id: String?
    let name: String?
    let location: LocationModel?
    let categories:[CategoryModel]?
    let referralId:String?
    let hasPerk:Bool?
    let delivery:[DeliveryModel]?
    let venuePage:[String:String]?
}

struct LocationModel:Decodable{
    let address: String?
    let crossStreet:String?
    let lat: Double?
    let lng:Double?
    let distance: Int?
    let postalCode:String?
    let cc:String?
    let city:String?
    let state:String?
    let country:String?
    let formattedAddress:[String]?
    let neighborhood:String?
}

struct CategoryModel:Decodable{
    let id:String?
    let name:String?
    let pluralName:String?
    let shortName:String?
    let icon:IconModel?
    let primary:Bool?
}

struct IconModel:Decodable{
    let prefix:String?
    let suffix:String?
}

struct DeliveryModel:Decodable{
    let id:String?
    let url:String?
    let provider:ProviderModel?
}

struct ProviderModel:Decodable{
    let name:String?
    let icon:ProviderIconModel?
}

struct ProviderIconModel:Decodable{
    let name:String?
    let sizes:[Int]
    let prefix:String?
}
