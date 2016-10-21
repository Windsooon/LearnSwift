//
//  ViewController.swift
//  MoneyBall
//
//  Created by Windson on 16/10/19.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var front_icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        front_icon.layoutIfNeeded()
        front_icon.layer.cornerRadius = front_icon.frame.height/2
        front_icon.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

