//
//  NetworkManager.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 13/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

protocol NetworkManager {
    
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    
}

extension NetworkManager {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    /// Decoding task which actually fetches the data from the URL Request
    ///
    /// - Parameters:
    ///   - request: URLRequest object
    ///   - decodingType: the generic type for the model to be converted
    ///   - completion: completion handler for JSON conversion success or failure
    /// - Returns: return the session data task
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let dataObj = data{
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: dataObj)
                        completion(genericModel, nil)
                    } catch {
                        print(error)
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else{
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    /// Fetch Data from API
    ///
    /// - Parameters:
    ///   - request: URLRequest object
    ///   - decode: closure to convert result to Model required
    ///   - completion: closure to return the result
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        if Reachability.isConnectedToNetwork(){
            let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
                
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
            task.resume()
        }
        else{
            completion(Result.failure(.noInternetError))
        }
    }
    
    /// Download image with url request
    ///
    /// - Parameters:
    ///   - request: URL request object
    ///   - completion: closure to return the result
    func downloadImage(with request: URLRequest, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        if Reachability.isConnectedToNetwork(){
            if let urlString = request.url?.absoluteString{
                if let cachedData = CacheManager.shared().object(forKey: urlString){
                    if let image = UIImage.init(data: cachedData){
                        completion(.success(image))
                    }
                    else{
                        completion(.failure(.invalidData))
                    }
                }
                else{
                    let task = session.dataTask(with: request, completionHandler: { data, response, error in
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            if let dataObj = data, error == nil {
                                CacheManager.shared().setObject(data: dataObj, forKey: urlString)
                                if let image = UIImage.init(data: dataObj){
                                    completion(.success(image))
                                }
                            }else{
                                completion(.failure(.invalidData))
                            }
                        } else {
                            completion(.failure(.responseUnsuccessful))
                        }
                    })
                    task.resume()
                }
            }
        }
        else{
            completion(Result.failure(.noInternetError))
        }
    }
}
