//
//  distanceTableViewCell.swift
//  yelp
//
//  Created by Scott Woody on 9/22/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class distanceTableViewCell: UITableViewCell {

    @IBOutlet weak var selectStateImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
