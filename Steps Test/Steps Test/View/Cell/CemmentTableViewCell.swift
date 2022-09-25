//
//  CemmentTableViewCell.swift
//  Steps Test
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import UIKit

class CemmentTableViewCell: UITableViewCell {
    @IBOutlet weak var posIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.posIdLabel.text = ""
        self.nameLabel.text = ""
        self.idLabel.text = ""
        self.emailLabel.text = ""
        self.bodyLabel.text = ""

    }
    
}
