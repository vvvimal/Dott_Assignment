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
            if let lat = restaurant.location?.lat, let lng = restaurant.location?.lng{
                let restaurantLocation = CLLocationCoordinate2DMake(lat, lng)
                let annotation = RestaurantMapAnnotation()
                annotation.coordinate = restaurantLocation
                annotation.title = restaurant.name
                annotationArray.append(annotation)
                
            }
            
        }
        return annotationArray
    }
}

extension RestaurantMapViewModel:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.getRestaurantList(mapRect:mapView.visibleMapRect)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
//    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//        self.getRestaurantList(mapRect:mapView.visibleMapRect)
//
//    }
}
