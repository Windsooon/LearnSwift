//
//  ListTableViewController.swift
//  MySampleApp
//
//  Created by Windson on 17/3/1.
//
//

import UIKit
import AWSDynamoDB

class ListTableViewController: UITableViewController {
    private var tables: [Table]?
    let cellTableIdentifier = "MoneyXibListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableCell()
        self.tableView.rowHeight = 140
        tables = NoSQLTableFactory.supportedTables

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let tables = tables else {return 0}
        return tables.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let table = tables![0]
        // Get item
        table.getItemWithCompletionHandler?({(response: AWSDynamoDBObjectModel?, error: NSError?) -> Void in
            if let error = error {
                self.showAlertWithTitle("Error", message: "Failed to load an item. \(error.localizedDescription)")
            }
            else if response != nil {
                print("----------------")
                print("2222")
            }
            else {
                self.showAlertWithTitle("Not Found", message: "No items match your criteria. Insert more sample data and try again.")
            }
        })
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! MoneyListCell
        cell.userName = table.tableDisplayName
        return cell
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func customTableCell() {
        let nib = UINib(nibName: "MoneyList", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellTableIdentifier)
    }
}
