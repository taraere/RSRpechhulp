//
//  InfoViewController.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 12/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit

class InfoViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var imageView: UIImageView?
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // add margins
        } else {
            // hide image
            imageView?.isHidden = true
        }
    }
}
