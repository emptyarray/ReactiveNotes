//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit

@objc protocol ReactiveView {
    func bindViewModel(viewModel: AnyObject)
}

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper<T: AnyObject> : NSObject {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    
    private let tableView: UITableView
    private let dataSource: DataSource
    
    let cellIdentifier = "Cell"
    
    //MARK: Public API
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, selectionAction: Action<Int, Int, NSError>, deleteAction: Action<Int, Int, NSError>) {
        self.tableView = tableView
        
        dataSource = DataSource(data: [AnyObject](), cellIdentifier: cellIdentifier, selectionAction: selectionAction, deleteAction: deleteAction)
        
        //self.tableView.registerClass(NoteCell.self, forCellReuseIdentifier: cellIdentifier)

        
        super.init()
        
        sourceSignal.start(next: {
            data in
            self.dataSource.data = data.map { $0 as AnyObject }
            
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            self.tableView.endUpdates()
        })
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var data: [AnyObject]
    var cellIdentifier: String
    let selectionAction: Action<Int, Int, NSError>
    let deleteAction: Action<Int, Int, NSError>
    
    init(data: [AnyObject], cellIdentifier: String, selectionAction: Action<Int, Int, NSError>, deleteAction: Action<Int, Int, NSError>) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.selectionAction = selectionAction
        self.deleteAction = deleteAction
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: AnyObject = data[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = NoteCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(item)
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectionAction.apply(indexPath.row).start()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            data.removeAtIndex(indexPath.row)
            
            deleteAction.apply(indexPath.row).start()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}