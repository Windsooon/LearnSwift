//
//  ActListController.swift
//
//
//  Created by Windson on 16/1/20.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ActListController: UITableViewController {
    let cellTableIdentifier = "ActIdentifier"
    var requestingActList = false
    var actPhotos = NSMutableOrderedSet()
    var currentPage = 1
    var actData = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTableCell()
        requestActList()
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("ActDetailIdentifier", sender: cell )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let listVC = segue.destinationViewController as! ActDetailsController
        listVC.actTest = "what"
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            requestActList()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actPhotos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! ActListCell
        
        let imageURL = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).url
        let title = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).title
        let content = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).content
        cell.imageView!.image = nil
        cell.request?.cancel()
        cell.actTitle = title
        cell.actContent = content
        
        cell.request = Alamofire.request(.GET, imageURL).responseImage() {
            response in
            if let image = response.result.value {
                cell.setNeedsLayout()
                cell.actThumbUrl.image = image
            }
            else {
                print("can't get image")
            }
        }
        
        return cell
            
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func customTableCell() {
        let nib = UINib(nibName: "ActListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellTableIdentifier)
    }
    
    func requestActList() {
        if requestingActList {
            return
        }
        
        requestingActList = true
        
        Alamofire.request(Unicooo.Router.ReadActList("",["page": self.currentPage])).validate().responseJSON {
            response in
                switch response.result {
                case .Success:
                    let JSON = response.result.value
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let photoInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                        ActPhotoInfo(id: ($0["id"] as! Int), url: $0["act_thumb_url"] as! String, title: $0["act_title"] as! String, content: $0["act_content"] as! String)
                    }
                    
                    let lastItem = self.actPhotos.count
                    
                    self.actPhotos.addObjectsFromArray(photoInfos)
                    
                    let indexPaths = (lastItem..<self.actPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    self.currentPage++
                    }
                    self.requestingActList = false
                case .Failure(let error):
                    print(error)
                }
            }
            // Notify that we are no longer populating photos
        }
    }
