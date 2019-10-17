//
//  LocationManager.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func locationPermissionError()
    func didGetNewLocation(location:CLLocation?)
    func setError(error:Error)
}


class LocationManager: NSObject {
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    var delegate: LocationManagerDelegate?
    
    // MARK: - Open data
    
    var currentLocation: CLLocation?
    
    
    // MARK: - Open methods

    /// Start the location updation
    func start() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            manager.requestLocation()
        case .restricted, .notDetermined, .denied:
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        @unknown default:
            fatalError("Location Permission Error")
        }
    }
    
    /// Stop the location updation
    func stop() {
        manager.stopUpdatingLocation()
    }
    
}

// MARK: - CLLocationManager Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    /// Location manager did change authorization
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager object
    ///   - status: Authorization status
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            delegate?.locationPermissionError()
        default: break
        }
        
    }
    
    /// Location manager did get location
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager object
    ///   - locations: Location array
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        let applicationState = UIApplication.shared.applicationState
        
        switch applicationState {
        case .active, .inactive, .background:
            updateLocation(lastLocation)
        @unknown default:
            fatalError("Location Tracking Error")
        }
    }
    
    /// Location fetch did fail method
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager object
    ///   - error: Error object
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.setError(error: error)
    }
    
}

// MARK: Manager methods
extension LocationManager {
    
    /// Update location depending on new location
    ///
    /// - Parameter location: CLLocation object
    private func updateLocation(_ location: CLLocation) {
        delegate?.didGetNewLocation(location: isNewLocation(location) ? location : nil)
        self.stop()
    }
    
    /// Is new location other than current location
    ///
    /// - Parameter location: CLLocation object
    /// - Returns: Bool
    private func isNewLocation(_ location: CLLocation) -> Bool{
        if self.currentLocation?.coordinate.latitude == location.coordinate.latitude && self.currentLocation?.coordinate.longitude == location.coordinate.longitude{
            return false
        }
        self.currentLocation = location
        return true
    }
    
}

