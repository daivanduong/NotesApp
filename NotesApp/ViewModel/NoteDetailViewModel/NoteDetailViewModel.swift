//
//  NoteDetailViewModel.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import Foundation
import UIKit
import CoreData

class NoteDetailViewModel: NoteDetailViewModelProtocol {
    var reloadUI: (() -> ())?
    
    var noteEdit: Notes?
    var listNotes: [Notes] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadNoteData(noteEdit: Notes?) -> String {
        var contentNote = ""
        if let note = noteEdit {
            contentNote = note.contentNote!
        }
        return contentNote
    }
    
    func handleDataNoteDetail( noteEdit: Notes?, contentNote: String) {
        if noteEdit == nil && contentNote.isEmpty == true {
            return
        } else {
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
                    addNote(note)
                } else {
                    if noteEdit?.contentNote != contentNote {
                        updateNote(noteEdit!, content: contentNote, title: titleForNote, description: descriptionForNote)
                    }
                }
            } else {
                deleteNote(at: noteEdit!)
            }
            reloadUI?()
        }
    }
    // Save
    func saveNote() {
        do {
              try context.save()
          } catch {
              print("error: \(error)")
          }
      }
      // Load
    func loadListNote() {
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sort = NSSortDescriptor(key: "timeCreated", ascending: false)
        request.sortDescriptors = [sort]
        do {
            listNotes =  try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
    }
    
    // Add
    func addNote(_ note: Notes) {
        saveNote()
    }
       
    // Update
    func updateNote(_ note: Notes, content: String, title: String, description: String) {
        note.contentNote = content
        note.titleNote = title
        note.descriptionNote = description
        note.timeCreated = Date()
        saveNote()
    }
    
    // Edit
    func editNote(index: IndexPath) -> Notes{
        return listNotes[index.row]
    }
       
    // Delete
    func deleteNote(at note: Notes) {
        context.delete(note)
        saveNote()
        
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
