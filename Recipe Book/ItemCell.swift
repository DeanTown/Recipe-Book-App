//
//  ItemCell.swift
//  Recipe Book
//
//  Created by Oliver Reckord Groten on 11/5/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        creatorLabel.adjustsFontForContentSizeCategory = true
        timeLabel.adjustsFontForContentSizeCategory = true
        
    }
    
}
