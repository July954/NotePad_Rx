//
//  NoteTableViewCell.swift
//  Notepad
//
//  Created by adcapsule on 2020/02/18.
//  Copyright © 2020 shAhn. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet var firstIv: UIImageView!
    @IBOutlet var titleLb: UILabel!
    @IBOutlet var contentLb: UILabel!
    @IBOutlet var writeDateLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
