//
//  NotesViewModel.swift
//  ReactiveNotes
//
//  Created by RB on 8/21/15.
//  Copyright (c) 2015 RB. All rights reserved.
//

import UIKit
import ReactiveCocoa

class NotesViewModel: NSObject {
    
    static let sharedInstance = NotesViewModel()
    
    var currentNote: MutableProperty<NoteViewModel>!
    var currentNoteIndex = MutableProperty<Int>(0)
    var notes = MutableProperty<[NoteViewModel]>([])
    
    let addNoteAction = Action<String, String, NSError>() { input in
        return SignalProducer { sink, _ in
            sendNext(sink, input)
            sendCompleted(sink)
        }
    }
    
    let editNoteAction = Action<String, String, NSError>() { input in
        return SignalProducer { sink, _ in
            sendNext(sink, input)
            sendCompleted(sink)
        }
    }
    
    let selectionAction = Action<Int, Int, NSError>() { index in
        return SignalProducer { sink, _ in
            sendNext(sink, index)
            sendCompleted(sink)
        }
    }

    let deleteAction = Action<Int, Int, NSError>() { index in
        return SignalProducer { sink, _ in
            sendNext(sink, index)
            sendCompleted(sink)
        }
    }

    
    override init() {
        super.init()
        
        addNoteAction.values.observe(next: {
            text in
                self.addNote(text)
                self.selectNote(0)
        })
        
        editNoteAction.values.observe(next: {
            self.editNote(self.currentNoteIndex.value, text: $0)
        })
        
        selectionAction.values.observe(next: {
            self.selectNote($0)
        })
        
        deleteAction.values.observe(next: {
            index in
                self.deleteNote(index)
                self.selectNote(0) // must select the first note!
        })
        
        currentNote = MutableProperty<NoteViewModel>(addNote(""))
    }
    
    func addNote(text: String) -> NoteViewModel {
        let note = NoteViewModel(noteText: text)
        
        var mutableNotes = notes.value
        mutableNotes.insert(note, atIndex: 0)
        notes.put(mutableNotes)
        
        return note
    }
    
    func deleteNote(index: Int) {
        var mutableNotes = notes.value
        mutableNotes.removeAtIndex(index)
        notes.put(mutableNotes)
    }
    
    func editNote(index: Int, text: String) {
        var mutableNotes = notes.value
        mutableNotes[index].text.put(text)
        notes.put(mutableNotes)
    }
    
    func selectNote(index: Int) {
        currentNote.put(notes.value[index])
        currentNoteIndex.put(index)
    }
}