//
//  ViewController.swift
//  order2
//
//  Created by Ansh Kaul on 9/5/20.
//  Copyright © 2020 Ansh Kaul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var order: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        order.layer.borderWidth = 0.5
        order.layer.borderColor = borderColor.cgColor
        order.layer.cornerRadius = 5.0
    }
    @IBAction func checkBoxTapped1( sender : UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    @IBAction func checkBoxTapped2( sender : UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    @IBAction func checkBoxTapped3( sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    @IBAction func checkBoxTapped4( sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}

