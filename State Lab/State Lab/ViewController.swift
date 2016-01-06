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
    private var smiley: UIImage!
    private var smileyView: UIImageView!
    private var segmentedControl: UISegmentedControl!
    private var index = 0
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
        
        let smileyFrame = CGRectMake(CGRectGetMidX(bounds) - 42, CGRectGetMidY(bounds)/2 - 42, 84, 84)
        smileyView = UIImageView(frame: smileyFrame)
        smileyView.contentMode = UIViewContentMode.Center
        let smileyPath = NSBundle.mainBundle().pathForResource("smiley", ofType: "png")
        smiley = UIImage(contentsOfFile: smileyPath!)
        smileyView.image = smiley
        
        segmentedControl = UISegmentedControl(items: ["One","Two", "Three", "Four"])
        segmentedControl.frame = CGRectMake(bounds.origin.x + 20, 50,
            bounds.size.width - 40, 30)
        segmentedControl.addTarget(self, action: "selectionChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        view.addSubview(segmentedControl)
        view.addSubview(smileyView)
        view.addSubview(label)
        
        index = NSUserDefaults.standardUserDefaults().integerForKey("index")
        segmentedControl.selectedSegmentIndex = index
        
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        center.addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        center.addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: "applicationWillEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
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
    
    func selectionChanged(sender:UISegmentedControl) {
        index = segmentedControl.selectedSegmentIndex;
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

    func applicationDidEnterBackground() {
        print("VC: \(__FUNCTION__)")
        self.smiley = nil
        self.smileyView.image = nil
        NSUserDefaults.standardUserDefaults().setInteger(self.index, forKey: "index")
    }
    
    func applicationWillEnterForeground() {
        print("VC: \(__FUNCTION__)")
        let smileyPath = NSBundle.mainBundle().pathForResource("smiley", ofType: "png")!
        smiley = UIImage(contentsOfFile: smileyPath)
        smileyView.image = smiley
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

