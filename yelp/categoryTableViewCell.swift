//
//  categoryTableViewCell.swift
//  yelp
//
//  Created by Scott Woody on 9/21/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class categoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var valueSwitch: UISwitch!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
