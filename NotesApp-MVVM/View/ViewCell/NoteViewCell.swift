//
//  NoteViewCell.swift
//  NotesApp-MVVM
//
//  Created by Đại Dương on 20/09/2025.
//

import UIKit

class NoteViewCell: UITableViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        viewCell.layer.cornerRadius = 10
        viewCell.layer.masksToBounds = true

        // Configure the view for the selected state
    }
    
}
