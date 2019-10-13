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
    func didGetLocation(location:CLLocation)
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
    
    
    // MARK: - Enums
    
    enum DistanceValue: Int {
        case meters, miles
    }
    
    // MARK: - Measuring properties
    
    private var startTimestamp = 0.0
    
    // MARK: - Open data
    
    var currentLocation: CLLocation?
    
    var previousLocation: CLLocation?
    
    // MARK: - Values
    
    private let metersPerMile = 1609.34
    
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
    
    func logOut() {
        manager.stopUpdatingLocation()
    }
    
}

// MARK: - Mode managing

extension LocationManager {
    
    open func enterBackground() {
        manager.stopUpdatingLocation()
    }
    
    open func enterForeground() {
        manager.startUpdatingLocation()
    }
    
}

// MARK: - CLLocationManager Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            delegate?.locationPermissionError()
        default: break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        let applicationState = UIApplication.shared.applicationState
        
        switch applicationState {
        case .active, .inactive:
            updateLocation(lastLocation)
        case .background:
            updateLocation(lastLocation)
        @unknown default:
            fatalError("Location Tracking Error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        delegate?.setError(error: error)
    }
    
    }

extension LocationManager {
    
    // MARK: - Managers
    
    private func updateLocation(_ location: CLLocation) {
        delegate?.didGetLocation(location: location)
        manager.stopUpdatingLocation()
        previousLocation = location
    }
    
}

