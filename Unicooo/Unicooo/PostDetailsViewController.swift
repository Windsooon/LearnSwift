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
        self.tableView.rowHeight = 400
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
        var number: Int!
        
        if section == 0 {
            number = 1
        }
        return number
    }

    func customeCell() {
        tableView.registerNib(UINib(nibName: "PostDetailsCell", bundle: nil), forCellReuseIdentifier: postDetailsIdentifier)
        tableView.registerNib(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: postCommentsIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(postDetailsIdentifier, forIndexPath: indexPath) as! PostDetailsCell
            cell.authorName = postAuthor
            cell.postDetails = postContent
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        else {
            return tableView.dequeueReusableCellWithIdentifier(postCommentsIdentifier, forIndexPath: indexPath) as! PostCommentsCell
        }
    }
}
