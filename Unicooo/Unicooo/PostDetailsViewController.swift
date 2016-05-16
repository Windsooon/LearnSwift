//
//  PostDetailsViewController.swift
//  Unicooo
//
//  Created by Windson on 16/5/11.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailsViewController: UITableViewController {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var postId: Int!
    var postMime: Int!
    var postAuthor: String!
    var postUrl: String!
    var postPosttime: String!
    var postContent: String!
    var postRadio: CGFloat!
    
    var postDetailsIdentifier: String = "PostDetailsIdentifier"
    var postCommentsIdentifier: String = "PostCommentsIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customeCell()
        requestPostDetails()
        self.tableView.rowHeight = 800
    }
    
    
    func requestPostDetails() {
        Alamofire.request(.GET, postUrl).responseImage() {
            response in
            if let image = response.result.value {
            }
            else {
                print("can't get image")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.screenSize.width/self.postRadio + 200
    }

    func customeCell() {
        tableView.registerNib(UINib(nibName: "PostDetailsCell", bundle: nil), forCellReuseIdentifier: postDetailsIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(postDetailsIdentifier, forIndexPath: indexPath) as! PostDetailsCell
        cell.authorName = postAuthor
        cell.postDetails = postContent
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if postMime == 0 { //image here
            let imageUrl = postUrl
            cell.postContent = nil
            cell.postHeightLayout = screenSize.width/self.postRadio
            cell.request?.cancel()
            cell.request = Alamofire.request(.GET, imageUrl).responseImage {
                response in
                guard let image = response.result.value where response.result.error == nil else { return }
                cell.setNeedsLayout()
                let imageView = UIImageView(frame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.width/self.postRadio))
                imageView.image = image
                cell.postContentView.addSubview(imageView)
            }
        }
        return cell
    }
}
