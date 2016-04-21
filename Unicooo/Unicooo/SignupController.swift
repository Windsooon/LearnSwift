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
    @IBOutlet weak var usernameField: UITextField!
    
    
    @IBAction func cancelSignUp(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func siguUp(sender: UIButton) {
        if (emailField.text?.characters.count > 6 && usernameField.text?.characters.count > 6 && passwordField.text?.characters.count > 8) {
            //if the field not empty
            Alamofire.request(Unicooo.Router.CreateUser(["email": emailField.text!, "user_name": usernameField.text!, "password": passwordField.text!])).validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        //Alamofire.request(.POST, REGISTER_ROUTER
                        print(response.response)
                    case .Failure(let error):
                        print("server may have some problem \(error)")
                    }
            }
        }
        else {
            print("some field is missing")
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
