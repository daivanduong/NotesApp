//
//  NoteDetailViewModel.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import Foundation
import UIKit

class NoteDetailViewModel: NoteDetailViewModelProtocol {
    var noteEdit: Notes?
    
    var onAdd: ((Notes) -> Void)?
    var onUpdate: ((Notes, String, String, String) -> Void)?
    var onDelete: (() -> Void)?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadNoteData(noteEdit: Notes?) -> String {
        var contentNote = ""
        if let note = noteEdit {
            contentNote = note.contentNote!
        }
        return contentNote
    }
    
    func handleDataNoteDetail( noteEdit: Notes?, contentNote: String) {
        let arrString = splitString(contentNote)
        if arrString[0].isEmpty == false {
            let titleForNote = arrString.first ?? ""
            let descriptionForNote = arrString.count > 1 ? arrString[1] : ""
            if noteEdit == nil {
                let note = Notes(context: context)
                note.contentNote = contentNote
                note.titleNote = titleForNote
                note.descriptionNote = descriptionForNote
                note.timeCreated = Date()
                onAdd?(note)
            } else {
                if noteEdit?.contentNote != contentNote {
                    onUpdate?(noteEdit!, contentNote, titleForNote, descriptionForNote)
                }
            }
            
        } else {
            onDelete?()
        }
    }
    
    func splitString(_ text: String) -> [String] {
        let contentNote = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if let range = contentNote.range(of: "\n") {
            let title = String(contentNote[..<range.lowerBound])
            let description = String(contentNote[range.upperBound...]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            return [title, description]
        }
        return [contentNote]
    }
}
