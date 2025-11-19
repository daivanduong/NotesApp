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
    var showAlert: Bool {get set}
    var listNotes: [Notes] {get}
    func getNumberOfRowsInSection() -> Int
    func getTitleInNote( index: IndexPath) -> String
    func getDescriptionInNote( index: IndexPath) -> String
    func saveNote()
    func loadListNote()
    func editNote(index: IndexPath) -> Notes
    func deleteNote(at indexPath: IndexPath)
    func formatChatDate(_ date: Date) -> String
    func searchNotes(_ searchText: String)
    func updateNoteCountLabel()
    
    
    
}
