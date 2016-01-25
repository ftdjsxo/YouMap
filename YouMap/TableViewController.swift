//
//  TableViewController.swift
//  YouMap
//
//  Created by Francesco Thiery on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import UIKit

protocol TableViewResDelegate{
    func didSelectRow(pin: Pin)
}

class TableViewController: UITableViewController {
    
    var results : [Pin]!
    var delegate : TableViewResDelegate!
    
    convenience init(delegate: TableViewResDelegate) {
        self.init()
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = results[indexPath.row].getTitle()
        cell.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate.didSelectRow(results[indexPath.row])
    }

    
}
