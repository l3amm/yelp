//
//  sortTableViewCell.swift
//  yelp
//
//  Created by Scott Woody on 9/21/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class sortTableViewCell: UITableViewCell {

    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
