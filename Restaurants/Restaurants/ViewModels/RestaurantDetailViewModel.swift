//
//  RestaurantDetailViewModel.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 16/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class RestaurantDetailViewModel: NSObject {
    var restaurant:RestaurantModel?
    
    /// Get restaurant detail string
    ///
    /// - Returns: Detail label text
    func getRestaurantDetailString() -> String{
        var addressString = "Address: "
        if let formattedStringArray = self.restaurant?.location?.formattedAddress, formattedStringArray.count > 0{
            for string in formattedStringArray{
                addressString.append(string)
                if self.restaurant?.location?.formattedAddress?.last != string{
                    addressString.append(", ")
                }
            }
        }
        else{
            addressString.append("NA")
        }
        var categoryString = "Category: "
        if let categoryDetail = self.restaurant?.categories, categoryDetail.count > 0{
            categoryString.append(categoryDetail[0].name ?? "NA")
        }
        else{
            categoryString.append("NA")
        }
        
        return "\(addressString)\n\(categoryString)"
    }
}
