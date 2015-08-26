//
//  NoteCell
//  ReactiveNotes
//
//  Created by RB on 8/22/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell, ReactiveView {
    
    func bindViewModel(viewModel: AnyObject) {
        if let note = viewModel as? NoteViewModel {
            self.textLabel!.text = note.text.value == "" ? "New Note" : note.text.value
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            self.detailTextLabel!.text = formatter.stringFromDate(note.createdAt.value)
        }
    }

}
