//
//  ViewController.swift
//  CodeForCoronaBaseFile
//
//  Created by Vedant Bahadur on 9/5/20.
//  Copyright © 2020 Youth Hacks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var View1: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        View1.layer.cornerRadius = 10;
        View1.layer.masksToBounds = true;
        View1.alpha = 0.5
        //View1.
    }
    
}

