//
//  RestaurantDetailViewController.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 14/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    /// Detail Label
    lazy var detailLabel: UILabel = {
        let dl = UILabel()
        dl.numberOfLines = 0
        dl.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(dl)
        dl.translatesAutoresizingMaskIntoConstraints = false
        return dl
    }()
    
    let viewModel = RestaurantDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /// Set restaurant object
    ///
    /// - Parameter restaurantObj: RestaurantModel object
    func setRestaurant(restaurantObj: RestaurantModel) {
        setupView()
        viewModel.restaurant = restaurantObj
        setRestaurantDetail()
    }
    
    /// Setup view
    func setupView(){
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0),
            detailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10.0),
            detailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0),
            detailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 21)
            ])
        detailLabel.isAccessibilityElement = true
        detailLabel.accessibilityLabel = "detailLabel"
        
    }
    
    /// Setup restaurant detail text
    func setRestaurantDetail(){
        self.title = viewModel.restaurant?.name
        self.detailLabel.text = viewModel.getRestaurantDetailString()
    }
}
