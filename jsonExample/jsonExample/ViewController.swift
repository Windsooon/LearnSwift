//
//  ViewController.swift
//  jsonExample
//
//  Created by Windson on 16/1/11.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var objects = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startRequest()
    }
    
    func startRequest() {
        var strURL = NSString(format: "http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=%&action=%@", "aiaison@sina.com", "JSON", "query")
        let url = NSURL(string: strURL as String)!
        var request = NSURLRequest(URL: url)
        var error: NSError!
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: &error)!
        
        if error != nil {
            NSLog("请求失败")
        }
        else {
            var resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary!
            self.reloadView(resDict)
        }
        NSLog("请求完成")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

