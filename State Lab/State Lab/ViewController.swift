//
//  ViewController.swift
//  State Lab
//
//  Created by Windson on 16/1/5.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var label: UILabel!
    private var animate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = view.bounds
        let labelFrame: CGRect = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50, bounds.size.width, 100)
        label = UILabel(frame: labelFrame)
        label.font = UIFont(name: "Helvetica", size: 70)
        label.text = "Bazinga!"
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        view.addSubview(label)
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        center.addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func rotateLabelDown() {
        UIView.animateWithDuration(0.5, animations: {
            self.label.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            },
            completion: {(bool) -> Void in
                self.rotateLabelUp()
            })
    }
    
    func rotateLabelUp() {
        UIView.animateWithDuration(0.5, animations: {
            self.label.transform = CGAffineTransformMakeRotation(0)
        },
            completion: {(bool) -> Void in
                if self.animate {
                    self.rotateLabelDown()
                }
        })
    }
    
    func applicationWillResignActive() {
        print("VC: \(__FUNCTION__)")
        animate = false
    }
    
    func applicationDidBecomeActive() {
        print("VC: \(__FUNCTION__)")
        animate = true
        rotateLabelDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

