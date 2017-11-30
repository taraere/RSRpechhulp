//
//  LocationManager.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 25/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private static let INSTANCE = LocationManager()
    
    private let manager: CLLocationManager = CLLocationManager()
    
    public var delegate: CLLocationManagerDelegate?
    
    class func instance() -> LocationManager {
        return INSTANCE
    }
    
    private override init() {
        super.init()
        
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    /**
     If no location, didFailWithError will be called
     */
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    /**
     Show alert if GPS is not available.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let delegate = self.delegate {
            delegate.locationManager!(manager, didFailWithError: error)
        }
        
        showGpsAlert()
    }
    
    /**
     Gets called by CLLocationManager when location is updated.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let delegate = self.delegate {
            delegate.locationManager!(manager, didUpdateLocations: locations)
        }
    }
    
    /**
     Alert window informing user on no GPS access for the app.
     */
    func showGpsAlert() {
        let gpsAlert = UIAlertController(title: "GPS aanzetten", message: "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen", preferredStyle: UIAlertControllerStyle.alert)
        
        gpsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        if let window = UIApplication.shared.keyWindow, let viewController = window.rootViewController {
            viewController.present(gpsAlert, animated: true, completion: nil)
        }
    }
    
}
