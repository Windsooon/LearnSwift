//
//  AddViewController.swift
//  MySampleApp
//
//  Created by Windson on 16/11/27.
//
//

import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class AddViewController: UIViewController {

    @IBOutlet weak var friend: UITextField!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var remarks: UITextField!
    
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
            print("you got me")
        }
        else {
            print("some field is missing")
        }
    }
}
