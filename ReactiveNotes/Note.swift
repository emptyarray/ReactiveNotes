//
//  Note.swift
//  ReactiveNotes
//
//  Created by RB on 8/21/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit
import ReactiveCocoa


class Note: NSObject {
   
    let text: MutableProperty<String>
    let createdAt: ConstantProperty<NSDate>

    init(noteText: String) {
        text = MutableProperty<String>(noteText)
        createdAt = ConstantProperty<NSDate>(NSDate())
    }
}
