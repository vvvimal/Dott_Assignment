//
//  ImageDownloadManager.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 14/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

struct ImageDownloadRequest: BaseRequest {
    
    var urlString: String = ""
    public init(imagePath: String) {
        self.urlString = imagePath
    }
}

class ImageDownloadManager:NetworkManager {
    
    let session: URLSession
    
    /// Init function with URLSession configuration
    ///
    /// - Parameter configuration: URLSessionConfiguration
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    /// Get Image file download request
    ///
    /// - Parameters:
    ///   - imageFileRequest: BaseRequest object for Unit test, else ImageDownloadRequest
    ///   - completion: Result consisting of the UIImage or APIError
    func getImageFile(from imageFileRequest: BaseRequest, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        
        if let requestObj = imageFileRequest.request{
            downloadImage(with: requestObj, completion: completion)
        }
        else{
            completion(Result.failure(.requestFailed))
        }
        
    }
}

