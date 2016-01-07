//
//  ViewController.swift
//  ScrollViewSample
//
//  Created by Windson on 16/1/7.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentView.frame = CGRectMake(0, 0, self.view.frame.width, 1000)
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000)
    }


}

