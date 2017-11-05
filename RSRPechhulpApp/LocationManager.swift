//
//  LocationManager.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 05/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    // get current location
    let manager: CLLocationManager
    
    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
        
    }
    // check location availability/ check GPS availability
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    
}
