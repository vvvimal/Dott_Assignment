//
//  RestaurantDetailViewController.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 14/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    private var restaurant:RestaurantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRestaurantDetails()
    }
    
    func setRestaurant(restaurantObj: RestaurantModel) {
        self.restaurant = restaurantObj
    }
    
    func setupRestaurantDetails(){
        self.title = self.restaurant?.name
        var addressString = "Address: "
        if let formattedStringArray = self.restaurant?.location?.formattedAddress{
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
        
        self.detailLabel.text = "\(addressString)\n\(categoryString)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
