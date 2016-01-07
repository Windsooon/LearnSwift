//
//  ViewController.swift
//  ProgressViewSample
//
//  Created by Windson on 16/1/7.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myActivityIndicatorView: UIActivityIndicatorView!
    var myTimer: NSTimer!
    
    @IBOutlet weak var myProgressView: UIProgressView!
    @IBAction func startToMove(sender: UIButton) {
        if (self.myActivityIndicatorView.isAnimating()) {
            self.myActivityIndicatorView.stopAnimating()
        }
        else {
            self.myActivityIndicatorView.startAnimating()
        }
    }
    @IBAction func downloadProgress(sender: UIButton) {
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "download", userInfo: nil, repeats: true)
    }
    func download() {
        self.myProgressView.progress = self.myProgressView.progress + 0.1
        if (self.myProgressView.progress == 1.0) {
            myTimer.invalidate()
            let alert: UIAlertView = UIAlertView(title: "download completed", message: "", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
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

