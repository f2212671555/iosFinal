//
//  MenuCategoryTableViewCell.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/23.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class MenuCategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!

    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
