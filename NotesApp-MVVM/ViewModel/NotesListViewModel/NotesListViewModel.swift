//
//  NotesListViewModel.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import Foundation
import UIKit
import CoreData


class NotesListViewModel: NotesListViewModelProtocol {
    
    var reloadUI: (() -> ())?
    
    var noteCount: Int?
    
    var listNotes: [Notes] = []
    
    var showAlert = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getNumberOfRowsInSection() -> Int {
        return listNotes.count
    }
    
    func getTitleInNote(index: IndexPath) -> String {
        guard let title = listNotes[index.row].titleNote else { return "" }
        return title
    }
    
    func getDescriptionInNote(index: IndexPath) -> String {
        let time = listNotes[index.row].timeCreated!
        let description = formatChatDate(time) + "  " + (listNotes[index.row].descriptionNote ?? "")
        return description
    }
    
    // Save
    func saveNote() {
          do {
              try context.save()
          } catch {
              print("error: \(error)")
          }
        updateNoteCountLabel()
      }
      // Load
      func loadListNote(with request: NSFetchRequest<Notes> = Notes.fetchRequest()) { 
          let request: NSFetchRequest<Notes> = Notes.fetchRequest()
          let sort = NSSortDescriptor(key: "timeCreated", ascending: false)
          request.sortDescriptors = [sort]
          
          do {
              listNotes =  try context.fetch(request)
              
          } catch {
              print("error: \(error)")
          }
          updateNoteCountLabel()
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
    func deleteNote(at indexPath: IndexPath) {
        let note = listNotes[indexPath.row]
        context.delete(note)
        listNotes.remove(at: indexPath.row)
        saveNote()
        reloadUI?()
    }
    
    
    func searchNotes(_ searchText: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        request.predicate = NSPredicate(format: "titleNote CONTAINS[c] %@", text)
        do {
            listNotes =  try context.fetch(request)
            if listNotes.count == 0 {
                showAlert = false
            } else {
                showAlert = true
            }
        } catch {
            print("error: \(error)")
        }
        if searchText.count == 0 {
            loadListNote()
            showAlert = true
        }
        updateNoteCountLabel()
        reloadUI?()
    }
    
    
    func formatChatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
            
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd/MM"
            return dayFormatter.string(from: date)
            
        } else {
            let fullFormatter = DateFormatter()
            fullFormatter.dateFormat = "dd/MM/yyyy"
            return fullFormatter.string(from: date)
        }
    }
    
    func updateNoteCountLabel() {
        noteCount = listNotes.count
    }

    
}
