//
//  ViewController.swift
//  ToolbarSample
//
//  Created by Windson on 16/1/7.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBAction func save(sender: UIBarButtonItem) {
        self.label.text = "hey save!"
    }
    
    @IBAction func add(sender: UIBarButtonItem) {
        self.label.text = "hey add!"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

