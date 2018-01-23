//
//  LayoutTableViewCell.swift
//  SwiftyLayoutsExample
//
//  Created by kaushal on 23/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit

class LayoutTableViewCell: UITableViewCell {
    @IBOutlet weak var layoutLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
