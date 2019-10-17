//
//  RestaurantMapViewController.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMapViewController: UIViewController {

    var mapView: MKMapView!
    let viewModel = RestaurantMapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupMapView()
        getCurrentLocation()
    }
    
    /// Setup initial view
    func setupView(){
        self.title = "Restaurants"
        viewModel.delegate = self
        LocationManager.shared.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Near Me",  style: .plain, target: self, action: #selector(self.getCurrentLocation))

    }
    
    /// Set up map view
    func setupMapView(){
        mapView = MKMapView.init(frame: self.view.frame)
        self.view.addSubview(mapView)
    }
    
    /// Setup map region depending on current location
    ///
    /// - Parameter userLocation: CLLocation object
    func setupMapRegion(userLocation: CLLocation){
        self.activityStartAnimating()
        mapView.delegate = viewModel
        let coordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    /// Get current location API call
    @objc func getCurrentLocation(){
        self.activityStartAnimating()
        LocationManager.shared.start()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == AppIdentifierStrings.kShowRestaurantDetailSegueIdentifier{
            if let detailView = segue.destination as? RestaurantDetailViewController, let restaurant = sender as? RestaurantModel{
                detailView.setRestaurant(restaurantObj: restaurant)
            }
        }
    }

}

extension RestaurantMapViewController:LocationManagerDelegate{
    
    /// Set update location error
    ///
    /// - Parameter error: Error object
    func setError(error: Error) {
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            self.showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    /// Location manager permission error
    func locationPermissionError() {
        self.showAlert(withTitle: "No permission", message: "In order to work, app needs your location", completionHandler: {
            guard let URL = Foundation.URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        })
    }
    
    /// Did get new location from location manager
    ///
    /// - Parameter location: CLLocation object
    func didGetNewLocation(location:CLLocation?) {
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            guard let newLocation = location else{ return }
            self.setupMapRegion(userLocation: newLocation)
        }
    }

}

extension RestaurantMapViewController:RestaurantMapDataUpdater{
    /// Show Detail
    ///
    /// - Parameter restaurant: restaurant model
    func showDetail(restaurant: RestaurantModel) {
        self.performSegue(withIdentifier: AppIdentifierStrings.kShowRestaurantDetailSegueIdentifier, sender: restaurant)
    }
    
    /// Reload Map View
    func reloadMapView() {
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(self.viewModel.getAnnotations())
        }
    }
    
    /// Error received from API request
    ///
    /// - Parameter error: APIError
    func setError(error:APIError){
        DispatchQueue.main.async() { () -> Void in
            self.activityStopAnimating()
            self.showAlert(withTitle: "Error", message: error.message)
        }
    }
}
