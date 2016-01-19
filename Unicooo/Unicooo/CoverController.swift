//
//  CoverController.swift
//  Unicooo
//
//  Created by Windson on 16/1/16.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class CoverController: UIViewController {
    
    private var signUpController: SignupController!
    private var logInController: LoginController!
    
    @IBAction func switchToSignUp(sender: UIButton) {
        signUpController = storyboard?.instantiateViewControllerWithIdentifier("SignUp") as! SignupController
        self.presentViewController(signUpController, animated:true, completion:nil)
    }
    
    @IBAction func switchToLogIn(sender: UIButton) {
    
    }
    
    private func switchViewController(toVC:UIViewController?) {
        if toVC != nil {
            self.addChildViewController(toVC!)
            self.view.insertSubview(toVC!.view, atIndex: 0)
            toVC!.didMoveToParentViewController(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
