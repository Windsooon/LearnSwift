//
//  ListTableViewController.swift
//  MySampleApp
//
//  Created by Windson on 17/3/1.
//
//

import UIKit

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
            guard let image = response.result.value, response.result.error == nil else { return }
            cell.setNeedsLayout()
            cell.actThumb = image
        }
        return cell
    }
    
    func customTableCell() {
        let nib = UINib(nibName: "ActListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellTableIdentifier)
    }
}
