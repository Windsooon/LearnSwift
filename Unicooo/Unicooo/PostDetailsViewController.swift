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
    var postCommentsCount: Int!
    var postlikes: Int!
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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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

    func barButtonItemWithImageNamed(imageName: String?, title: String?, action: Selector? = nil) -> UIBarButtonItem {
        let button = UIButton(type: .Custom)
        
        if imageName != nil {
            button.setImage(UIImage(named: imageName!)!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        
        if title != nil {
            button.setTitle(title, forState: .Normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
            
            let font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            button.titleLabel?.font = font
        }
        
        let size = button.sizeThatFits(CGSize(width: 90.0, height: 30.0))
        button.frame.size = CGSize(width: min(size.width + 10.0, 60), height: size.height)
        
        if action != nil {
            button.addTarget(self, action: action!, forControlEvents: .TouchUpInside)
        }
        
        let barButton = UIBarButtonItem(customView: button)
        
        return barButton
    }
    
    func addButtomBar() {
        var items = [UIBarButtonItem]()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        items.append(barButtonItemWithImageNamed("hamburger", title: nil, action: #selector(self.showComments)))
        
        if postCommentsCount > 0 {
            items.append(barButtonItemWithImageNamed("bubble", title: "\(postCommentsCount ?? 0)", action: #selector(self.doLike)))
        }
        
        items.append(flexibleSpace)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(self.showAction)))
        items.append(flexibleSpace)
        
        items.append(barButtonItemWithImageNamed("like", title: "\(postlikes ?? 0)"))
        
        self.setToolbarItems(items, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func showComments() {
    
    }
    
    func doLike() {
    
    }
    
    func showAction() {
    
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
