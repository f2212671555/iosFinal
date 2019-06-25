//
//  PersonTableViewCell.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/17.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personCellImageView: UIImageView!
    @IBOutlet weak var personCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
