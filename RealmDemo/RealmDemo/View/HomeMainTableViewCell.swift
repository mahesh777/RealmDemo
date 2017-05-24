//
//  HomeMainTableViewCell.swift
//  RealmDemo
//
//  Created by Mahesh Sonaiya on 24/05/17.
//  Copyright © 2017 TestProject. All rights reserved.
//

import UIKit

class HomeMainTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonTitleLabel: UILabel!
    @IBOutlet weak var lessonStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
