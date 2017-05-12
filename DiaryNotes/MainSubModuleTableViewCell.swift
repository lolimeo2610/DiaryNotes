//
//  MainSubModuleTableViewCell.swift
//  DiaryNotes
//
//  Created by Minh Huy Tran on 12/5/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit

class MainSubModuleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameModuleLabel: UILabel!
    @IBOutlet weak var subModuleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
