//
//  ActLIstCell.swift
//  Unicooo
//
//  Created by Windson on 16/1/21.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class ActListCell: UITableViewCell {
    var actTitle: String = "" {
        didSet {
            if (actTitle != oldValue) {
                actTitleLabel.text = actTitle
            }
        }
    }
    
    var actContent: String = "" {
        didSet {
            if (actContent != oldValue) {
                actContentLabel.text = actContent
            }
        }
    }

    @IBOutlet var actTitleLabel: UILabel!
    @IBOutlet var actContentLabel: UILabel!
    @IBOutlet var actAuthorLabel: UILabel!
    @IBOutlet var actThumbUrl: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
