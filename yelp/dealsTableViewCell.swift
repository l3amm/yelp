//
//  dealsTableViewCell.swift
//  yelp
//
//  Created by Scott Woody on 9/22/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class dealsTableViewCell: UITableViewCell {

    @IBOutlet weak var dealsSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
