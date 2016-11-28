//
//  MoneyListCell.swift
//  MySampleApp
//
//  Created by Windson on 16/11/29.
//
//

import UIKit

class MoneyListCell: UITableViewCell {
    

    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    
    var userName: String = "" {
        didSet {
            if (userName != oldValue) {
                userNameLabel.text = userName
            }
        }
    }
    
    var money: String = "" {
        didSet {
            if (money != oldValue) {
                moneyLabel.text = money
            }
        }
    }
    
    var comments: String = "" {
        didSet {
            if (comments != oldValue) {
                commentsLabel.text = comments
            }
        }
    }
    
    var userAvatar: UIImage! {
        didSet {
            if (userAvatar != oldValue) {
                userAvatarImage.image = userAvatar
            }
        }
    }
}
