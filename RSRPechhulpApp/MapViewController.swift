//
//  MapViewController.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 05/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController {
    private final var ANIM_DUR: Double = 0.4
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var showCallPopupButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        popUpView.center = self.view.center
        self.view.addSubview(popUpView)
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
        
    }
    
}
