//
//  Extensions.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Showing alert for generic messages
    ///
    /// - Parameters:
    ///   - title: title of the message
    ///   - message: message body
    func showAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { action in}
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// Activity Indicator start animation
    func activityStartAnimating() {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.view.addSubview(backgroundView)
        self.view.bringSubviewToFront(backgroundView)
        
    }
    
    /// Activity Indicator stop animation
    func activityStopAnimating() {
        if let background = self.view.viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
    }
}
