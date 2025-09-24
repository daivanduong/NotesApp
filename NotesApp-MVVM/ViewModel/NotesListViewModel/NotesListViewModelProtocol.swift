//
//  NotesListViewModelProtoco;.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import Foundation
import CoreData

protocol NotesListViewModelProtocol {
    var reloadUI: (() -> ())? { get set }
    var noteCount: Int? { get set}
    func getNumberOfRowsInSection() -> Int
    func getTitleInNote( index: IndexPath) -> String
    func getDescriptionInNote( index: IndexPath) -> String
    func saveNote()
    func loadListNote(with request: NSFetchRequest<Notes>)
    func addNote(_ note: Notes)
    func updateNote(_ note: Notes, content: String, title: String, description: String)
    func editNote(index: IndexPath) -> Notes
    func deleteNote(at indexPath: IndexPath)
    func formatChatDate(_ date: Date) -> String
    func updateNoteCountLabel()
    
    
    
}
