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
    var requestingActList = false
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actData.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activities List"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActListCell = tableView.dequeueReusableCellWithIdentifier("ActIdentifier", forIndexPath: indexPath) as! ActListCell
        var dict = actData[indexPath.row]
        if let url = NSURL(string: dict["act_thumb_url"] as! String) {
            if let data = NSData(contentsOfURL: url) {
                let actThumbImage = UIImage(data: data)
                cell.actThumbUrl.image = actThumbImage
            }
            
        }
        cell.actTitle = dict["act_title"] as! String
        cell.actContent = dict["act_content"] as! String
        //cell.textLabel?.text = dict["act_title"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func customTableCell() {
        self.tableView.registerClass(ActListCell.self, forCellReuseIdentifier: "ActIdentifier")
        let nib = UINib(nibName: "ActListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ActIdentifier")
    }
    
    func requestActList() {
        if requestingActList {
            return
        }
        requestingActList = true
        Alamofire.request(Unicooo.Router.ReadActList("",["page": self.currentPage]))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let JSONDATA = JSON(response.result.value!)
                        if let resultsData = JSONDATA["results"].arrayObject {
                            self.actData = resultsData as! [[String:AnyObject]]
                        }
                        if self.actData.count > 0 {
                            self.tableView.reloadData()
                        }
                    }
                case .Failure(let error):
                    //server haven't open and 404 api request problem
                    print(error.code)
                }
            }
    }
    
}
