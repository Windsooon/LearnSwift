//
//  NoSQLTableListViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.6
//

import Foundation
import UIKit

class NoSQLTableListViewController: UITableViewController {
    
    private var tables: [Table]?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        tables = NoSQLTableFactory.supportedTables

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let tables = tables else {return 0}
        return tables.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoSQLTableListCell", forIndexPath: indexPath) as! NoSQLTableListCell
        let table = tables![indexPath.section]
        cell.tableNameLabel.text = table.tableDisplayName
        cell.partitionKeyLabel.text = "\(table.tableAttributeName!(table.partitionKeyName)) (\(table.partitionKeyType))"
        cell.sortKeyLabel.text = "-"
        if let sortKey = table.sortKeyName {
            cell.sortKeyLabel.text = "\(table.tableAttributeName!(sortKey)) (\(table.sortKeyType!))"
        }
        cell.numberOfIndexesLabel.text = "\(table.indexes.count)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let showQueryResultSeque = "NoSQLShowTableDetailsSegue"
        performSegueWithIdentifier(showQueryResultSeque, sender: tables![indexPath.section])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? NoSQLTableViewController {
            destinationViewController.table = sender as? Table
        }
    }
}

class NoSQLTableListCell: UITableViewCell {

    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var partitionKeyLabel: UILabel!
    @IBOutlet weak var sortKeyLabel: UILabel!
    @IBOutlet weak var numberOfIndexesLabel: UILabel!
}
