//
//  CacheManager.swift
//  Restaurants
//
//  Created by Venugopalan, Vimal on 14/10/19.
//  Copyright © 2019 Venugopalan, Vimal. All rights reserved.
//

import UIKit

fileprivate let dataCache = NSCache<AnyObject, AnyObject>()

class CacheManager {
    
    private static var sharedInstance:CacheManager!
    
    /// singleton instance of cachemanager
    ///
    /// - Parameters:
    ///   - costLimit: cost limit of the data cached
    ///   - countLimit: count limit of the data cached
    ///   - isDiscardableContent: is content discardable
    /// - Returns: CacheManager object
    static func shared(costLimit:Int? = nil, countLimit:Int? = nil, isDiscardableContent:Bool? = false) -> CacheManager{
        if sharedInstance != nil{
            return sharedInstance
        }
        else{
            sharedInstance = CacheManager()
            if let costValue = costLimit {
                dataCache.totalCostLimit = costValue
            }
            if let countValue = countLimit{
                dataCache.countLimit = countValue
            }
            if let discardFlag = isDiscardableContent{
                dataCache.evictsObjectsWithDiscardedContent = discardFlag
            }
            return sharedInstance
        }
    }
    
    private init() {
        
    }
    
    /// Set object for key
    ///
    /// - Parameters:
    ///   - data: data set in cache
    ///   - key: string representing url
    func setObject(data:Data, forKey key:String){
        dataCache.setObject(data as AnyObject, forKey: key as AnyObject)
    }
    
    /// Get object for key
    ///
    /// - Parameter key: string representing the url
    /// - Returns: Data from cache
    func object(forKey key:String) -> Data?{
        return dataCache.object(forKey: key as AnyObject) as? Data
    }
}
