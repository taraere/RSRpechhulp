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

    // Contant variables
    private final var ANIM_DUR: Double = 0.4
    private final var PHONE_NUM: String = "+31 900 7788 990"
    
    // Location related variables
    let manager: CLLocationManager = CLLocationManager()
    let dropPin = MKPointAnnotation()
    var annotation: Annotation?
    var location: CLLocation?
    var didZoom: Bool = false
    
    //
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showCallPopupButton: UIView!
    
    override func viewDidLoad() {
        /*
         Call when View is loaded:
                Call popup is insibile
                Request user authorization to get GPS location
                Start updating user's location
                MapView is loaded.
         */
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
        /*
         Once popup for calling is dismissed, disable its touchability, and animate out.
         */
        self.showCallPopupButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: ANIM_DUR) {
            self.showCallPopupButton.alpha = 1
        }
        
        popUpView.isUserInteractionEnabled = false
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 0
            if let annotation = self.annotation {
                annotation.alpha = 1
            }
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }
    }
    
    @IBAction func showCallPopup(_ sender: AnyObject) {
        /*
         Once popup for calling is visible, the annotation, label to the pointer, "Uw locatie", is made invisible.
         "Bel RSR nu" button is also invisible.
         Make popup invisible, and animate in.
         */
        self.showCallPopupButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: ANIM_DUR) {
            self.showCallPopupButton.alpha = 0
            if let annotation = self.annotation {
                annotation.alpha = 0
            }
        }
        
        popUpView.isUserInteractionEnabled = true
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func callButton(_ sender: AnyObject) {
        /*
         Call popup, with cancel option. Will call number on screen.
         */
        let strPhone = "tel:\(self.PHONE_NUM)".replacingOccurrences(of: " ", with: "")
        if let url = URL(string: strPhone), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        /*
         Checks for GPS access, returns alert "GPS aanzetten".
         */
        print("Error while updating location " + error.localizedDescription)
        
        let refreshAlert = UIAlertController(title: "GPS aanzetten", message: "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
         If called viewDidLoad, update location, or if location is changed, so as to be called a minimal amount of times.
         */
        if let location = manager.location {
            updateLocation(location)
        }
    }
    
    func updateLocation(_ location: CLLocation!) {
        /*
         Return location, marker/ drop pin, and zoom into the location.
         */
        self.location = location
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /*
         Create mapView screen.
         Place annotation, the "Uw locatie" label, on mapView.
         Make content of annotation specific to the user's location.
         */
        self.annotation = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? Annotation
        if self.annotation == nil {
            self.annotation = Annotation(annotation: annotation, reuseIdentifier: "annotation")
        }
        
        // Get address from GPS coordinates.
        if let location = self.location {
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                if let placeMark = placemarks?[0] {
                    var address = ""
                    // Location name, e.g. house number
                    if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                        address = address.appending(locationName as String).appending(", ").appending("\n")
                    }
                    // Zip code/ postal code
                    if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                        address = address.appending(zip as String).appending(", ")
                    }
                    // City
                    if let city = placeMark.addressDictionary!["City"] as? NSString {
                        address = address.appending(city as String)
                    }
                    print(address)
                    
                    self.annotation?.setAddress(address: address)
                }
            })
        }
    
        return self.annotation;
    }
}
