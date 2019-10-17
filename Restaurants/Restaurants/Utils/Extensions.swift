//
//  Extensions.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Showing alert for generic messages with action
    ///
    /// - Parameters:
    ///   - title: title of the message
    ///   - message: message body
    ///   - completionHandler: optional action handler
    func showAlert(withTitle title: String, message : String, completionHandler:(() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { action in
            if let actionHandler = completionHandler{
                actionHandler()
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Activity Indicator start animation
    
    func activityStartAnimating() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.isUserInteractionEnabled = false
        
        self.view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    /// Activity Indicator stop animation
    func activityStopAnimating() {
        for view in self.view.subviews {
            if let subView = view as? UIActivityIndicatorView {
                subView.removeFromSuperview()
                break
            }
        }
        self.view.isUserInteractionEnabled = true
    }
}

extension Date{
    func getCurrentDateString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
}
