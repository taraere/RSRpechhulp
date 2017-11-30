//
//  ViewController.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 03/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var infoButton: UIView!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // iPad specific views
        if UIDevice.current.userInterfaceIdiom == .pad {
            barButtonItem.image = nil
            barButtonItem.title = nil
            infoButton.isHidden = false
            topConstraint?.constant = 60
        } else {
            infoButton.isHidden = true
        }
    }
}
