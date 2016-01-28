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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activities List"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! ActListCell
        
        let imageURL = (actPhotos.objectAtIndex(indexPath.row) as! ActPhotoInfo).url
        
        cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/*"]).responseImage() {
            response in
            
            //If you did not receive an error and you downloaded a proper photo, cache it for later
            if let img = response.result.value where response.result.error == nil {
                
                //Set the cell’s image accordingly
                self.imageCache.setObject(img, forKey: response.request!.URLString)
                
                cell.imageView.image = img
            } else {
                /*
                If the cell went off-screen before the image was downloaded, we cancel it and
                an NSURLErrorDomain (-999: cancelled) is returned. This is a normal behavior.
                */
            }
        }
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
        
        Alamofire.request(Unicooo.Router.ReadActList("",["page": self.currentPage])).responseJSON {
            response in
            if let JSON = response.result.value {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    
                    let photoInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                            ActPhotoInfo(id: ($0["id"] as! Int), url: $0["act_thumb_url"] as! String)
                    }
                    
                    let lastItem = self.actPhotos.count
                    
                    self.actPhotos.addObjectsFromArray(photoInfos)
                    
                    let indexPaths = (lastItem..<self.actPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    
                    self.currentPage++
                }
            }
            // Notify that we are no longer populating photos
            self.requestingActList = false
        }
    }
}