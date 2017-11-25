//
//  Annotation.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 12/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit
import MapKit

class AnnotationLabel: MKPinAnnotationView {
    
    let annotationView: AnnotationView = AnnotationView.loadFromNibNamed(nibNamed: "AnnotationView")! as! AnnotationView
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {    
        annotationView.frame.origin.x = -(annotationView.frame.size.width * 0.5) + 5
        annotationView.frame.origin.y = -annotationView.frame.size.height
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(annotationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setAddress(address: String) {
        annotationView.setAddress(address: address)
    }
}

class AnnotationView: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    
    func setAddress(address: String) {
        addressLabel.text = address
    }
}

/**
 Extension on UIView to instantiate a view with a nib.
 */
extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
