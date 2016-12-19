//
//  FacebookLoginViewController.swift
//  MySampleApp
//
//  Created by Windson on 16/12/19.
//
//

import UIKit
import AWSMobileHubHelper
import FBSDKLoginKit

class FacebookLoginViewController: UIViewController {
    
    var didSignInObserver: AnyObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Sign In Loading.")
        
        didSignInObserver =  NSNotificationCenter.defaultCenter().addObserverForName(AWSIdentityManagerDidSignInNotification,
            object: AWSIdentityManager.defaultIdentityManager(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(note: NSNotification) -> Void in
                print("logined")
        })
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            if error == nil {
                dispatch_async(dispatch_get_main_queue(),{
                    let frontPageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FrontPage") as! FrontPageViewController
                    self.presentViewController(frontPageViewController, animated:true, completion:nil)
                })
            }
            print("result = \(result), error = \(error)")
        })
    }
    
    @IBAction func handleFacebookLogin() {
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
