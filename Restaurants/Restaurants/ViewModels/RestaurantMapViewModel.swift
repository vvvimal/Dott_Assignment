//
//  RestaurantMapViewModel.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit
import MapKit

protocol RestaurantMapDataUpdater: class {
    func reloadMapView()
    func setError(error:APIError)
    func showDetail(restaurant: RestaurantModel)
}

class RestaurantMapViewModel: NSObject {
    
    var restaurantList = [RestaurantModel]()
    private let restaurantListGetManager = RestaurantListGetManager()
    weak var delegate : RestaurantMapDataUpdater?

    
    func getRestaurantList(mapRect:MKMapRect){
        let neMapPoint = MKMapPoint(x: mapRect.maxX, y: mapRect.origin.y)
        let swMapPoint = MKMapPoint(x: mapRect.origin.x, y: mapRect.maxY)
        
        let neCoordString:String = "\(neMapPoint.coordinate.latitude),\(neMapPoint.coordinate.longitude)"
        let swCoordString:String = "\(swMapPoint.coordinate.latitude),\(swMapPoint.coordinate.longitude)"

        self.restaurantList.removeAll()
        restaurantListGetManager.getRestaurantList(from: RestaurantListGetRequest(northEast: neCoordString, southWest: swCoordString ), completion: { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.restaurantList.append(contentsOf: responseModel?.response.venues ?? [])
                self?.delegate?.reloadMapView()
            case .failure(let error):
                self?.delegate?.setError(error: error)
            }
        })
        
    }
    
    func getAnnotations() -> [MKAnnotation]{
        var annotationArray:[MKAnnotation] = []
        for restaurant in restaurantList{
            let annotation = RestaurantMapAnnotation(restaurant: restaurant)
            annotationArray.append(annotation)
        }
        return annotationArray
    }
}

extension RestaurantMapViewModel:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.getRestaurantList(mapRect:mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationObj = annotation as? RestaurantMapAnnotation{
            let identifier = AppIdentifierStrings.kRestaurantAnnotationReuseIdentifier
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? RestaurantMapAnnotationView{
                annotationView.annotation = annotation
                annotationView.imagePath = annotationObj.iconPath
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIButton
                return annotationView

            }
            else {
                let annotationView = RestaurantMapAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.imagePath = annotationObj.iconPath
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIButton
                return annotationView

            }
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? RestaurantMapAnnotation, let restaurant = annotation.restaurantObj {
                delegate?.showDetail(restaurant: restaurant)
            }
        }
    }
}
