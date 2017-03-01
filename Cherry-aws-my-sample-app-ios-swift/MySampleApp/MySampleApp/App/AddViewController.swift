//
//  AddViewController.swift
//  MySampleApp
//
//  Created by Windson on 16/11/27.
//
//

import UIKit
import Foundation
import AWSDynamoDB
import AWSMobileHubHelper

class AddViewController: UIViewController {

    @IBOutlet weak var friend: UITextField!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var remarks: UITextField!
    
    var table: Table?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func textFieldDoneEditing(sender: UITextField){
        sender.resignFirstResponder()
    }

    @IBAction func backgroundTap(sender: UIControl){
        friend.resignFirstResponder()
        money.resignFirstResponder()
        remarks.resignFirstResponder()
    }
    
    @IBAction func addRecord(sender: UIButton){
        // 增加借还纪录
        if (friend.text?.characters.count >= 0 && (money.text?.characters.count) >= 0 && remarks.text?.characters.count >= 0 && Int(money.text!) != nil) {
            let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
            var errors: [NSError] = []
            let group: dispatch_group_t = dispatch_group_create()
            let itemForGet = OweMoney()
            // 获取当前时间戳最后四位
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            let dateString = dateFormatter.stringFromDate(date)
            //let time_str = String(NSDate().timeIntervalSince1970)
            //let last4 = time_str.substringFromIndex(time_str.endIndex.advancedBy(-4))
            itemForGet._userId = AWSIdentityManager.defaultIdentityManager().identityId!
            itemForGet._otherUserFacebookId = "unset"
            itemForGet._otherUserId = friend.text
            itemForGet._status = 1
            itemForGet._money = Int(money.text!)
            itemForGet._createdDate = dateString
            itemForGet._updatedDate = dateString
            
            dispatch_group_enter(group)
            
            
            objectMapper.save(itemForGet, completionHandler: {(error: NSError?) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        errors.append(error!)
                        print("error")
                    })
                }
                print("successed")
                dispatch_group_leave(group)
            })
        }
        else {
            print("some field is missing")
        }
    }
    
    @IBAction func returnFrontPage(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
