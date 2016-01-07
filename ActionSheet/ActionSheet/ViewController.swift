//
//  ViewController.swift
//  ActionSheet
//
//  Created by Windson on 16/1/7.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate, UIActionSheetDelegate{

    @IBAction func testActionSheet(sender: AnyObject) {
        let actionSheet: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle:  "取消", destructiveButtonTitle: "distory", otherButtonTitles: "Facebook", "Twitter")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("buttonIndex = '\(buttonIndex)'")
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

