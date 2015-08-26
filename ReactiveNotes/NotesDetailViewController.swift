//
//  DetailViewController.swift
//  ReactiveNotes
//
//  Created by RB on 8/21/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit
import ReactiveCocoa

class NotesDetailViewController: UIViewController {

    @IBOutlet weak var textView: TextView!
    
    let notesViewModel = NotesViewModel.sharedInstance

    func configureView() {
        if let tv = textView {
            tv.text = notesViewModel.currentNote.value.text.value
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        automaticallyAdjustsScrollViewInsets = false
        
        // since I'm doing a one-way binding, I will use that binding
        // to observe the UITextView
        // skip the first value to avoid blanking it out during setup
        textView.rac_text.producer |> skip(1) |> start(next: {
            notesViewModel.editNoteAction.apply($0).start()
        })
        

        // this is how I wanted to set the text, but it was causing an infinite cycle
        // I would need two-way binding to do this right:
//        textView.rac_text <~
//            notesViewModel.currentNote.producer |> flatMap(.Latest) { $0.text.producer }
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNote:")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = notesViewModel.currentNote.value.text.value
    }

    
    func addNote(sender: AnyObject) {
        textView.endEditing(true)
        notesViewModel.addNoteAction.apply("").start()
        textView.text = notesViewModel.currentNote.value.text.value
    }


}

