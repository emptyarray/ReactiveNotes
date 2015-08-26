//
//  MasterViewController.swift
//  ReactiveNotes
//
//  Created by RB on 8/21/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit
import ReactiveCocoa

// because Swift cannot find it if I put in another file... bug?
extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem()
        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
    }
}

class NotesMasterViewController: UITableViewController {

    var detailViewController: NotesDetailViewController? = nil
    
    let notesViewModel = NotesViewModel.sharedInstance
    private var bindingHelper: TableViewBindingHelper<NoteViewModel>!

    @IBOutlet var notesTable: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // this came from the default Apple project
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.title = "Notes"
        title = "Notes"
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? NotesDetailViewController
        }
        
        bindingHelper = TableViewBindingHelper(tableView: notesTable,
            sourceSignal: notesViewModel.notes.producer,
            selectionAction: notesViewModel.selectionAction,
            deleteAction: notesViewModel.deleteAction
        )
        
        notesViewModel.selectionAction.values.observe(next: {
            _ in
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                self.splitViewController?.toggleMasterView()
                self.performSegueWithIdentifier("showDetail", sender: nil)
            }
        })
        
        notesViewModel.currentNoteIndex.producer.start(next: {
            index in
            self.notesTable.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: false, scrollPosition: .Middle)
        })
        

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let detail = detailViewController {
            detail.configureView()
        }
    }
    

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! NotesDetailViewController
            controller.configureView()
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

}

