//
//  PostDetailsViewController.swift
//  Unicooo
//
//  Created by Windson on 16/5/11.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer
import MobileCoreServices

class PostDetailsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var postId: Int!
    var postMime: Int!
    var postAuthor: String!
    var postAvatar: String!
    var postCommentsCount: Int!
    var postLikes: Int!
    var postUrl: String!
    var postPosttime: String!
    var postContent: String!
    var postRadio: CGFloat!
    
    var postDetailsIdentifier: String = "PostDetailsIdentifier"
    var postCommentsIdentifier: String = "PostCommentsIdentifier"
    
    var moviePlayerController:MPMoviePlayerController?
    var postNewImage:UIImage?
    var postNewMovieURL:NSURL?
    var postNewLastChosenMediaType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customeCell()
        requestPostDetails()
        addButtomBar()
        self.tableView.rowHeight = 800
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        items.append(barButtonItemWithImageNamed("bubble", title: nil, action: #selector(self.showComments)))
        items.append(flexibleSpace)
        items.append(barButtonItemWithImageNamed("heart", title: nil, action: #selector(self.doLike)))
        items.append(flexibleSpace)
        items.append(barButtonItemWithImageNamed("like", title: nil, action: #selector(self.joinAct)))
        self.setToolbarItems(items, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func showComments() {
        let postDetailsCommentsController = storyboard?.instantiateViewControllerWithIdentifier("PostDetailsComments") as? PostDetailsCommentsController
        //postDetailsCommentsController?.modalPresentationStyle = .Popover
        //postDetailsCommentsController?.modalTransitionStyle = .CoverVertical
        postDetailsCommentsController?.postId = postId
        //postDetailsCommentsController?.popoverPresentationController?.delegate = self
        self.navigationController!.pushViewController(postDetailsCommentsController!, animated: true)
        //presentViewController(postDetailsCommentsController!, animated: true, completion: nil)
    
    }
    
    func joinAct() {
        let optionMenu = UIAlertController(title: nil, message: "Join Act", preferredStyle: .ActionSheet)
        let newAction = UIAlertAction(title: "New Photo or Video", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
        })
        let pickAction = UIAlertAction(title: "Pick from Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(newAction)
        optionMenu.addAction(pickAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
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
        cell.likesCount = postLikes
        cell.commentsCount = postCommentsCount
        //cell.authorThumb = nil
        //cell.request?.cancel()
        
       
        let authorThumbUrl = httpsUrl + postAvatar + actCoverSmall
        if postAvatar != nil {
            Alamofire.request(.GET, authorThumbUrl).responseImage {
                response in
                guard let image = response.result.value where response.result.error == nil else { return }
                cell.authorThumb = image
            }
        }
        
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
    
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title:"Error accessing media", message: "Unsupported media source.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        postNewLastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        let postNewController = self.storyboard?.instantiateViewControllerWithIdentifier("PostNewController") as! PostNewController
        if let mediaType = postNewLastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                postNewImage = info[UIImagePickerControllerEditedImage] as? UIImage
                postNewController.postNewImage = postNewImage
                presentViewController(postNewController, animated: true, completion: nil)
            } else if mediaType == kUTTypeMovie as NSString {
                postNewMovieURL = info[UIImagePickerControllerMediaURL] as? NSURL
                postNewController.postNewNSURL = postNewMovieURL
                presentViewController(postNewController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
}
