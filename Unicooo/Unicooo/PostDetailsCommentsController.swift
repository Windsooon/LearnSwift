//
//  PostDetailsCommentsController.swift
//  Unicooo
//
//  Created by Windson on 16/5/24.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailsCommentsController: UITableViewController {
    let cellTableIdentifier = "PostCommentsIdentifier"
    var requestingCommentsList = false
    var commentSet = NSMutableOrderedSet()
    var currentPage = 1
    var postId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        
        commentsCustomTableCell()
        requestCommentsList()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(PostDetailsCommentsController.dismiss))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentSet.count
    }
    
    func commentsCustomTableCell() {
        let nib = UINib(nibName: "PostCommentsCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellTableIdentifier)
    }
    
    func dismiss() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func requestCommentsList() {
        if requestingCommentsList {
            return
        }
        requestingCommentsList = true
        Alamofire.request(Unicooo.Router.ReadCommentList(["page": self.currentPage, "post_id": self.postId])).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                let JSON = response.result.value
                let commentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                dispatch_async(commentQueue) {
                    let commentDetailsInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                        CommentsInfo(id: ($0["id"] as! Int), url: httpsUrl + ($0["comment_user"]!["user_avatar"] as! String) + avatarSetting, content: ($0["comment_content"] as! String), author: ($0["comment_author"] as! String), createTime: ($0["comment_create_time"] as! String))
                    }
                    
                    let lastItem = self.commentSet.count
                    self.commentSet.addObjectsFromArray(commentDetailsInfos)
                    let indexPaths = (lastItem..<self.commentSet.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    self.currentPage += 1
                }
                self.requestingCommentsList = false
            case .Failure(let error):
                print(error)
            }
        }
        // Notify that we are no longer populating photos
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! PostCommentsCell
        //let imageURL = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).url
        //let title = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).title
        //let content = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).content
        //cell.actTitle = title
        //cell.actContent = content
        cell.commentAuthorName = (commentSet.objectAtIndex(indexPath.row) as! CommentsInfo).author
        cell.commentText = (commentSet.objectAtIndex(indexPath.row) as! CommentsInfo).content
        //cell.request?.cancel()
        //
        //cell.request = Alamofire.request(.GET, imageURL).responseImage {
        //    response in
        //    guard let image = response.result.value where response.result.error == nil else { return }
        //    cell.setNeedsLayout()
        //    cell.actThumb = image
        //}
        return cell
    }
    
    //override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //{
    //    return 100.0;//Choose your custom row height
    //}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
