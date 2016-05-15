//
//  PostCommentsCell.swift
//  Unicooo
//
//  Created by Windson on 16/5/14.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

class PostCommentsCell: UITableViewCell {
    
    var commentAuthorThumb: UIImage! {
        didSet {
            if (commentAuthorThumb != oldValue) {
                commentAuthorImage.image = commentAuthorThumb
            }
        }
    }
    
    var commentAuthorName: String = "" {
        didSet {
            if (commentAuthorName != oldValue) {
                commentAuthorNameLabel.text = commentAuthorName
            }
        }
    }
    
    var commentTime: String = "" {
        didSet {
            if (commentTime != oldValue) {
                commentTimeLabel.text = commentTime
            }
        }
    }
    
    var commentText: String = "" {
        didSet {
            if (commentText != oldValue) {
                commentTextText.text = commentText
            }
        }
    }
    
    
    @IBOutlet weak var commentAuthorImage: UIImageView!
    @IBOutlet weak var commentAuthorNameLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentTextText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
