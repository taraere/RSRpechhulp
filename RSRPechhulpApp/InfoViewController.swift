//
//  InfoViewController.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 12/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//

import UIKit

class InfoViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame.size.height = scrollView.contentSize.height
    }
}
