//
//  Annotation.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 12/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit
import MapKit

class Annotation: MKPinAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        let view = AnnotationView.loadFromNibNamed(nibNamed: "AnnotationView")!
        view.frame.origin.x = -(view.frame.size.width * 0.5) + 5
        view.frame.origin.y = -view.frame.size.height
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AnnotationView: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    
    func setAddress(address: String) {
        addressLabel.text = address
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
