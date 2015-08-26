//
//  TextView.swift
//  ReactiveNotes
//
//  Created by RB on 8/25/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TextView: UITextView, UITextViewDelegate {
    
    var rac_text = MutableProperty<String>("")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        
        rac_text.producer.start(next: {
            newValue in
                self.text = newValue
        })
        
        textContainerInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
    
    func textViewDidChange(textView: UITextView) {
        rac_text.put(text)
    }


}
