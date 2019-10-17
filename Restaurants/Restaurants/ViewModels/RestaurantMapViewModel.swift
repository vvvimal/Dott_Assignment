//
//  RestaurantMapViewModel.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit
import MapKit

/// Restaurant data updation protocol
protocol RestaurantMapDataUpdater: class {
    func reloadMapView()
    func setError(error:APIError)
    func showDetail(restaurant: RestaurantModel)
}

class RestaurantMapViewModel: NSObject {
    
    var restaurantList = [RestaurantModel]()
    private let restaurantListGetManager = RestaurantListGetManager()
    weak var delegate : RestaurantMapDataUpdater?

    
    /// Get restaurant list from API
    ///
    /// - Parameter mapRect: MKMapRect object
    func getRestaurantList(mapRect:MKMapRect){
        
        let (northEast, southWest) = getCoordinates(mapRect: mapRect)
        
        self.restaurantList.removeAll()

        restaurantListGetManager.getRestaurantList(from: RestaurantListGetRequest(northEast: northEast, southWest: southWest), completion: { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.restaurantList.append(contentsOf: responseModel?.response.venues ?? [])
                self?.delegate?.reloadMapView()
            case .failure(let error):
                self?.delegate?.setError(error: error)
            }
        })
    }
    
    /// Get coordinates from map rect
    ///
    /// - Parameter mapRect: MKMapRect object
    /// - Returns: String for NorthEast and SouthWest coordinates
    func getCoordinates(mapRect:MKMapRect) -> (String, String){
        let neMapPoint = MKMapPoint(x: mapRect.maxX, y: mapRect.origin.y)
        let swMapPoint = MKMapPoint(x: mapRect.origin.x, y: mapRect.maxY)
        
        let neCoordString:String = "\(neMapPoint.coordinate.latitude),\(neMapPoint.coordinate.longitude)"
        let swCoordString:String = "\(swMapPoint.coordinate.latitude),\(swMapPoint.coordinate.longitude)"
        
        return (neCoordString, swCoordString)
    }
    
    /// Get annotation from restaurant list
    ///
    /// - Returns: MKAnnotation array
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
    
    /// Region of the map did change
    ///
    /// - Parameters:
    ///   - mapView: MKMapView object
    ///   - animated: Bool
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.getRestaurantList(mapRect:mapView.visibleMapRect)
    }
    
    /// View for annotation on Map
    ///
    /// - Parameters:
    ///   - mapView: MKMapView object
    ///   - annotation: MKAnnotation object
    /// - Returns: Annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationObj = annotation as? RestaurantMapAnnotation{
            let identifier = AppIdentifierStrings.kRestaurantAnnotationReuseIdentifier
            if let tag = mapView.annotations.firstIndex(where: {$0.title == annotationObj.title}){
                if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? RestaurantMapAnnotationView{
                    annotationView.annotation = annotation
                    annotationView.imagePath = annotationObj.iconPath
                    annotationView.canShowCallout = true
                    
                    let disclosureButton = UIButton.init(type: .detailDisclosure) as UIButton
                    annotationView.rightCalloutAccessoryView = disclosureButton
                    annotationView.accessibilityLabel = "\(identifier)_\(tag)"
                    return annotationView
                }
                else {
                    let annotationView = RestaurantMapAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView.imagePath = annotationObj.iconPath
                    annotationView.canShowCallout = true
                    
                    let disclosureButton = UIButton.init(type: .detailDisclosure) as UIButton
                    annotationView.rightCalloutAccessoryView = disclosureButton
                    annotationView.accessibilityLabel = "\(identifier)_\(tag)"
                    return annotationView
                }
            }
            
        }
        return nil
    }

    /// Map view annotation view callout tap event.
    ///
    /// - Parameters:
    ///   - mapView: MKMapview object
    ///   - view: tapped annotation object
    ///   - control: accessory view
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? RestaurantMapAnnotation, let restaurant = annotation.restaurantObj {
                delegate?.showDetail(restaurant: restaurant)
            }
        }
    }
}
