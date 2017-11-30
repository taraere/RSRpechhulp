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
    
    @IBOutlet weak var leftMargin: NSLayoutConstraint?
    @IBOutlet weak var rightMargin: NSLayoutConstraint?
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            leftMargin?.constant = 50
            rightMargin?.constant = 50
        } else {
            // hide image
            imageView?.isHidden = true
        }
    }
}
