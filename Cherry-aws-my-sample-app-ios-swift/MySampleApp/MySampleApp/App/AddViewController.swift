//
//  AddViewController.swift
//  MySampleApp
//
//  Created by Windson on 16/11/27.
//
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var friendField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func textFieldDoneEditing(sender: UITextField){
        sender.resignFirstResponder()
    }

    @IBAction func backgroundTap(sender: UIControl){
        friendField.resignFirstResponder()
    }
}
