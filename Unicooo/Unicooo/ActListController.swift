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
    // status tell request actlist or not
    var requestingActList = false
    var actPhotos = NSMutableOrderedSet()
    var currentPage = 1
    //for search act
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        customTableCell()
        requestActList()
        searchAct()
        self.tableView.rowHeight = 140
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("ActDetailIdentifier", sender: cell )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let actDetails = segue.destinationViewController as! PostListController
        actDetails.actId = (actPhotos.objectAtIndex(indexPath!.row) as! ActPhotoInfo).id
    }
    
    //load more when you scroll to 80% of the bottom of screen
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8 {
            requestActList()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.actTitle = title
        cell.actContent = content
        cell.actThumb = nil
        cell.request?.cancel()
        
        cell.request = Alamofire.request(.GET, imageURL).responseImage {
            response in
            guard let image = response.result.value where response.result.error == nil else { return }
            cell.setNeedsLayout()
            cell.actThumb = image
        }
        return cell
    }
    
    func customTableCell() {
        let nib = UINib(nibName: "ActListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellTableIdentifier)
    }
    
    func searchAct() {
        //add details for search results
        let resultsController = SearchResultsTableViewController()
        searchController = UISearchController(searchResultsController: resultsController)
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Enter the Act Id."
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchController.searchResultsUpdater = resultsController
    }
    
    func requestActList() {
        if requestingActList {
            return
        }
        requestingActList = true
        Alamofire.request(Unicooo.Router.ReadActList(["page": self.currentPage, "act_type": 2])).validate().responseJSON {
            response in
                switch response.result {
                case .Success:
                    let JSON = response.result.value
                    let actQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                    dispatch_async(actQueue) {
                        let photoInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                            ActPhotoInfo(id: ($0["id"] as! Int), url: httpsUrl + ($0["act_thumb_url"] as! String) + actCoverSmall, title: ($0["act_title"] as! String), content: ($0["act_content"] as! String), author: ($0["act_user"]!["user_name"] as! String), createTime: ($0["act_create_time"] as! String))
                        }
                        
                        let lastItem = self.actPhotos.count
                        
                        self.actPhotos.addObjectsFromArray(photoInfos)
                        let indexPaths = (lastItem..<self.actPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                        self.currentPage += 1
                    }
                    self.requestingActList = false
                case .Failure(let error):
                    print(error)
                }
            }
            // Notify that we are no longer populating photos
        }
    }

    //get statusbar height
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
