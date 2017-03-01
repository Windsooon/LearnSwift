//
//  FrontPageViewController.swift
//  MySampleApp
//
//  Created by Windson on 16/11/27.
//
//

import UIKit
import AWSMobileHubHelper

class FrontPageViewController: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let identityManager = AWSIdentityManager.defaultIdentityManager()
        
        if let identityUserName = identityManager.userName {
            userName.text = identityUserName
        } else {
            userName.text = NSLocalizedString("Guest User", comment: "Placeholder text for the guest user.")
        }
        
        if let imageURL = identityManager.imageURL {
            let imageData = NSData(contentsOfURL: imageURL)!
            if let profileImage = UIImage(data: imageData) {
                userAvatar.image = profileImage
            } else {
                userAvatar.image = UIImage(named: "UserIcon")
            }
        }
    }
    
    @IBAction func addDebt(sender: UIButton) {
        let addViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addViewController") as! AddViewController
        self.presentViewController(addViewController, animated: true, completion: nil)
    }
 
    @IBAction func debtList(sender: UIButton) {
        let listTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("listTableViewController") as! ListTableViewController
        self.presentViewController(listTableViewController, animated: true, completion: nil)
    }
}
