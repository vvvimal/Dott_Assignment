//
//  RestaurantMapAnnotation.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var iconPath: String?
    var colour: UIColor?

    var restaurantObj: RestaurantModel?
    
    convenience init(restaurant: RestaurantModel) {
        if let lat = restaurant.location?.lat, let lng = restaurant.location?.lng{
            let restaurantLocation = CLLocationCoordinate2DMake(lat, lng)
            var iconPathString = ""
            if let categories = restaurant.categories, categories.count > 0{
                if let imagePrefix = categories[0].icon?.prefix, let imageSuffix = categories[0].icon?.suffix {
                    iconPathString = "\(imagePrefix)bg_64\(imageSuffix)"
                }
            }
            self.init(coordinate:restaurantLocation, title:restaurant.name, iconPath: iconPathString)
            self.restaurantObj = restaurant

        }
        else{
            self.init()
        }

    }

    private init(coordinate: CLLocationCoordinate2D, title:String?, iconPath:String) {
        self.coordinate = coordinate
        self.title = title
        self.iconPath = iconPath
        self.colour = UIColor.white
    }
    
    private override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.iconPath = nil
        self.colour = nil
    }
}

class RestaurantMapAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!
    private let imageDownloadManager = ImageDownloadManager()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        self.addSubview(self.imageView)
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imagePath: String? {
        didSet {
            self.imageView.image = UIImage.init(named: "RestaurantPinIcon")
            if let imagePathObj = imagePath{
                let imageDownloadRequest = ImageDownloadRequest(imagePath: imagePathObj)
                imageDownloadManager.getImageFile(from: imageDownloadRequest, completion: { [weak self] result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async() {
                            self?.imageView.image = image
                        }
                    case .failure( _):
                        break
                    }
                    
                })
            }
        }
    }
}
