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

    @IBOutlet weak var mapView: MKMapView!
    let viewModel = RestaurantMapViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupLocationManager()
        getCurrentLocation()
    }
    
    func setupView(){
        self.title = "Restaurants"
        viewModel.delegate = self
    }
    
    func setupLocationManager(){
        LocationManager.shared.delegate = self
    }
    
    func setupMapView(userLocation: CLLocation){
        let coordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.delegate = viewModel;
        mapView.setRegion(region, animated: false)
    }
    
    func getCurrentLocation(){
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
    func setError(error: Error) {
        self.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
    
    func locationPermissionError() {
        let alertController = UIAlertController(title: "No permission",
                                                message: "In order to work, app needs your location", preferredStyle: .alert)
        let openSettings = UIAlertAction(title: "Open settings", style: .default, handler: {
            (action) -> Void in
            guard let URL = Foundation.URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            
        })
        alertController.addAction(openSettings)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didGetLocation(location: CLLocation) {
        self.setupMapView(userLocation: location)
    }

}

extension RestaurantMapViewController:RestaurantMapDataUpdater{
    func showDetail(restaurant: RestaurantModel) {
        self.performSegue(withIdentifier: AppIdentifierStrings.kShowRestaurantDetailSegueIdentifier, sender: restaurant)
    }
    
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
