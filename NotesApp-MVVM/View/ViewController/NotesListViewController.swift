//
//  ViewController.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    
    @IBOutlet weak var noteTableView: UITableView!
    
    @IBOutlet weak var addNewNoteButton: UIButton!
    
    @IBOutlet weak var imgAlert: UIImageView!
    
    @IBOutlet weak var noteCountLable: UILabel!
    
    let viewModel = NotesListViewModel()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSearchBar()
        setuptableView()
        imgAlert.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        addNewNoteButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addNewNoteButton.tintColor = .systemYellow
        viewModel.loadListNote()
        noteCountLable.text = "\(viewModel.noteCount ?? 0) Notes"
        viewModel.reloadUI = {
            self.noteCountLable.text = "\(self.viewModel.noteCount ?? 0) Notes"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
            viewModel.loadListNote()
            noteTableView.reloadData()
            noteCountLable.text = "\(viewModel.noteCount ?? 0) Notes"

      }
    
    func setupSearchBar(){
        navigationController?.navigationBar.tintColor = .systemYellow
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController?.searchBar.delegate = self
        
    }
    func setuptableView(){
        noteTableView.separatorStyle = .none
        noteTableView.delegate = self
        noteTableView.dataSource = self
        let nib = UINib(nibName: "NoteViewCell", bundle: nil)
        noteTableView.register(nib, forCellReuseIdentifier: "noteViewCell")
        
    }
    
    
    @IBAction func addNewNodeButtonPressed(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "noteDetailViewController") as! NoteDetailViewController
        vc.viewModel.onAdd = { note in
            self.viewModel.addNote( note)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: TableView Method



extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteViewCell", for: indexPath) as! NoteViewCell
        cell.titleLable.text = viewModel.getTitleInNote(index: indexPath)
        cell.descriptionLable.text = viewModel.getDescriptionInNote(index: indexPath)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "noteDetailViewController") as! NoteDetailViewController
        vc.noteEdit = viewModel.editNote(index: indexPath)
        
        vc.viewModel.onUpdate = { note, contentNote, titleNote, descriptionNote in
            self.viewModel.updateNote(note, content: contentNote, title: titleNote, description: descriptionNote)
        }
        vc.viewModel.onDelete = {
            self.viewModel.deleteNote(at: indexPath)
        }
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView,
                                commit editingStyle: UITableViewCell.EditingStyle,
                                forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNote(at: indexPath)
            noteTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: SerachBar Method

extension NotesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        viewModel.searchNotes(searchText)
        noteTableView.reloadData()
        imgAlert.isHidden = viewModel.showAlert
        viewModel.reloadUI = {
            self.noteCountLable.text = "\(self.viewModel.noteCount ?? 0) Notes"
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imgAlert.isHidden = true
        viewModel.loadListNote()
        noteCountLable.text = "\(viewModel.noteCount ?? 0) Notes"

        noteTableView.reloadData()
    }

}
