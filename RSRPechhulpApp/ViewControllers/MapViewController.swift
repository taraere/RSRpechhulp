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
    let dropPin = MKPointAnnotation()
    var annotation: AnnotationLabel?
    var location: CLLocation?
    var didZoom: Bool = false
    
    // Connections to views in the xib
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showCallPopupButton: UIView!
    @IBOutlet weak var callView: UIView!
    
    /**
     Call when View is loaded:
     Call popup is invisibile
     Request user authorization to get GPS location
     Start updating user's location
     MapView is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // make button invisible and unclickable
            showCallPopupButton.isHidden = true
        } else {
            // button visible, textview hidden
            callView.isHidden = true
        }
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        popUpView.center = self.view.center
        self.view.addSubview(popUpView)
        
        LocationManager.instance().delegate = self
        
        mapView.delegate = self
    }
    
    /**
     Make popup visible, and animate it in.
     */
    @IBAction func showCallPopup(_ sender: AnyObject) {
        self.showCallPopupButton.isUserInteractionEnabled = false
        animateButtonAndAnnotation(alpha: 0)
        
        popUpView.isUserInteractionEnabled = true
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    /**
     Once popup for calling is visible, the annotation,
     label to the pointer titled "Uw locatie", is made invisible.
     "Bel RSR nu" button is also invisible.
     */
    func animateButtonAndAnnotation(alpha: CGFloat) {
        UIView.animate(withDuration: ANIM_DUR) {
            self.showCallPopupButton.alpha = alpha
            if let annotation = self.annotation {
                annotation.alpha = alpha
            }
        }
    }
    
    /**
     Once popup for calling is dismissed, disable its touchability, and animate out.
     */
    @IBAction func dismissCallPopup(_ sender: AnyObject) {
        self.showCallPopupButton.isUserInteractionEnabled = true
        animateButtonAndAnnotation(alpha: 1)
        
        popUpView.isUserInteractionEnabled = false
        UIView.animate(withDuration: ANIM_DUR) {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        }
    }
    
    /**
     Will call number of RSR.
     */
    @IBAction func callButton(_ sender: UIButton) {
        let strPhone = "tel:\(self.PHONE_NUM)".replacingOccurrences(of: " ", with: "")
        if let url = URL(string: strPhone), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /**
     Gets called by LocationManager when location is updated.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            updateLocation(location)
        }
    }
    
    /**
     Use location to update pin, and zoom into the location if it is the first time.
     */
    func updateLocation(_ location: CLLocation!) {
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
    
    /**
     Place annotation, the "Uw locatie" label, on the pin.
     Make content of annotation specific to the user's location.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.annotation = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? AnnotationLabel
        if self.annotation == nil {
            self.annotation = AnnotationLabel(annotation: annotation, reuseIdentifier: "annotation")
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
