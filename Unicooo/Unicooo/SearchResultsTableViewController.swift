//
//  SearchResultsTableViewController.swift
//  Unicooo
//
//  Created by Windson on 16/4/19.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchTableIdentifier = "ActIdentifier"
    var searchResultDict: [String: String] = [:]
    var searchResultArray: [String] = []
    var actPhotos = NSMutableOrderedSet()
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let numbersCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        searchResultArray.removeAll(keepCapacity: true)
        
        if let searchString = searchController.searchBar.text {
            // tell the string only contains numbers
            if searchString.rangeOfCharacterFromSet(numbersCharacters) == nil && searchString.characters.count == 1 {
                    searchAct(searchString)
            }
        }
        tableView.reloadData()
    }

    func searchAct(id: String) {
        Alamofire.request(Unicooo.Router.ReadActList(["act_id": id]))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let actSearchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                    dispatch_async(actSearchQueue) {
                        let json = JSON(response.result.value!)
                        let act_title = json["results"][0]["act_title"].stringValue
                        let act_content = json["results"][0]["act_content"].stringValue
                        let act_thumb_url = json["results"][0]["act_thumb_url"].stringValue
                        self.searchResultArray = [act_title, act_content, act_thumb_url]
                        let indexPaths = (0..<1).map { NSIndexPath(forItem: $0, inSection: 0)}
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    func customTableCell() {
        let nib = UINib(nibName: "ActListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: searchTableIdentifier)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 140
        customTableCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //    // #warning Incomplete implementation, return the number of sections
    //    return 1
    //}

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.searchResultArray.count > 0) ? 1 : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchTableIdentifier, forIndexPath: indexPath) as! ActListCell
        
        let title = self.searchResultArray[0]
        let content = self.searchResultArray[1]
        let imageURL = self.searchResultArray[2]
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
