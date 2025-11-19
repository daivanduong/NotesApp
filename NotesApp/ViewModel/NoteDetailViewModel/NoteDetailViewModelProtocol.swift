//
//  NoteDetailViewModelProtocol.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import Foundation


protocol NoteDetailViewModelProtocol {
    var reloadUI: (() -> ())? {get set}
    var noteEdit: Notes? {get set}
    func loadNoteData(noteEdit: Notes?) -> String
    func handleDataNoteDetail( noteEdit: Notes?, contentNote: String)
    func splitString(_ text: String) -> [String]
}
