//
//  SignupController.swift
//  Unicooo
//
//  Created by Windson on 16/1/15.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class SignupController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func cancelSignUp(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func siguUp(sender: UIButton) {
        Alamofire.request(.GET, "http://127.0.0.1:8000/api/posts/1/")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.nextField = passwordField
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //override func viewDidLayoutSubviews() {
    //    super.viewDidLayoutSubviews()
    //    let border = CALayer()
    //    let width = CGFloat(1.0)
    //    border.borderColor = UIColor.darkGrayColor().CGColor
    //    border.frame = CGRect(x: 0, y: emailField.frame.size.height - width, width: emailField.frame.size.width, height: emailField.frame.size.height)
    //    
    //    border.borderWidth = width
    //    emailField.layer.addSublayer(border)
    //    emailField.layer.masksToBounds = true
    //}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordField {
            textField.resignFirstResponder()
        }
        return true
    }
    

}
