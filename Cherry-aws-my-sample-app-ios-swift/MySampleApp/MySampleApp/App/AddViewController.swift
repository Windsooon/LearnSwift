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
        if (friend.text?.characters.count >= 1 && money.text?.characters.count >= 1 && remarks.text?.characters.count >= 0) {
            let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
            var errors: [NSError] = []
            let group: dispatch_group_t = dispatch_group_create()
            
            let itemForGet = OweMoney()
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            let dateString = dateFormatter.stringFromDate(date)
            
            itemForGet._userId = AWSIdentityManager.defaultIdentityManager().identityId!
            itemForGet._createdDate = dateString
            itemForGet._money = 1
            itemForGet._otherUserFacebookId = "1"
            itemForGet._otherUserId = "1"
            itemForGet._status = 1
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
}
