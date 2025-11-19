//
//  NoteDetailViewController.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var viewModel: NoteDetailViewModelProtocol!
    var noteEdit: Notes?
    
    @IBOutlet weak var textViewNote: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .systemYellow
        textViewNote.delegate = self
        self.textViewNote.text = self.viewModel?.loadNoteData(noteEdit: self.noteEdit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textViewNote.becomeFirstResponder()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            viewModel?.handleDataNoteDetail(noteEdit: noteEdit, contentNote: textViewNote.text)

        }
    }
    
    
    @objc func doneButtonTaped() {
        textViewNote.resignFirstResponder()
    }
}


extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTaped))
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = nil
    }
}
