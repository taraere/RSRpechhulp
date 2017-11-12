//
//  MapViewController.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 05/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private final var ANIM_DUR: Double = 0.4
    
    private final var PHONE_NUM: String = "+31 900 7788 990"
    
    let dropPin = MKPointAnnotation()
    let manager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    var didZoom: Bool = false
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var showCallPopupButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        popUpView.center = self.view.center
        self.view.addSubview(popUpView)
        
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
        
        mapView.delegate = self
    }
    
    @IBAction func dismissCallPopup(_ sender: AnyObject) {
        self.showCallPopupButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: ANIM_DUR) {
            self.showCallPopupButton.alpha = 1
        }
        
        popUpView.isUserInteractionEnabled = false
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }
    }
    
    @IBAction func showCallPopup(_ sender: AnyObject) {
        self.showCallPopupButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: ANIM_DUR) {
            self.showCallPopupButton.alpha = 0
        }
        
        popUpView.isUserInteractionEnabled = true
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func callButton(_ sender: AnyObject) {
        let s = "tel:\(self.PHONE_NUM)".replacingOccurrences(of: " ", with: "")
        if let url = URL(string: s), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        return location
    }
    
    func updateLocation(_ location: CLLocation!) {
        dropPin.coordinate = location.coordinate
        mapView.addAnnotation(dropPin)
        
        // Zoom
        if !didZoom {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            didZoom = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            updateLocation(location)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        if annotationView == nil {
            annotationView = Annotation(annotation: annotation, reuseIdentifier: "annotation")
        }
        return annotationView;
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        
        let refreshAlert = UIAlertController(title: "GPS aanzetten", message: "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
