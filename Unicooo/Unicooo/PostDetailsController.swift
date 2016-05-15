//
//  PostDetailsController.swift
//  Unicooo
//
//  Created by Windson on 16/3/15.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailsController: UIViewController {

    @IBOutlet var PostDetailsView: UIView!
    @IBOutlet weak var postDetailsImage: UIImageView!
    @IBOutlet weak var postDetailsAuthor: UILabel!
    
    @IBOutlet weak var postDetailsPosttime: UILabel!
    
    @IBOutlet weak var postDetailsContent: UILabel!
    
    @IBOutlet weak var postDetailsImageConstraint: NSLayoutConstraint!
    
    private var postImageWidth: CGFloat {
        return CGRectGetWidth(self.view.bounds)
    }
   
    var postId: Int!
    var postAuthor: String!
    var postMime: Int!
    var postUrl: String!
    var postPosttime: String!
    var postContent: String!
    var postRadio: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestPostDetails()
        postDetailsAuthor.text = postAuthor
        postDetailsPosttime.text = postPosttime
        postDetailsContent.text = postContent
        postDetailsImageConstraint.constant = postImageWidth/postRadio
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func requestPostDetails() {
        Alamofire.request(.GET, postUrl).responseImage() {
            response in
            if let image = response.result.value {
                //self.postDetailsImage.frame = CGRectMake(0, 0, self.postImageWidth, self.postImageWidth/self.postRadio)
                self.postDetailsImage.image = image
            }
            else {
                print("can't get image")
            }
        }
    }

}
