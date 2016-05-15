//
//  PostDetailsCell.swift
//  Unicooo
//
//  Created by Windson on 16/5/14.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailsCell: UITableViewCell {
    var request: Alamofire.Request?
    var authorName: String = "" {
        didSet {
            if (authorName != oldValue) {
                authorNameLabel.text = authorName
            }
        }
    }
    
    var postDetails: String = "" {
        didSet {
            if (postDetails != oldValue) {
                postDetailsText.text = postDetails
            }
        }
    }
    
    var authorThumb: UIImage! {
        didSet {
            if (authorThumb != oldValue) {
                authorImage.image = authorThumb
            }
        }
    }
    
    var likesCount: String = "" {
        didSet {
            if (likesCount != oldValue) {
                likesCountLabel.text = likesCount
            }
        }
    }
    
    var commentsCount: String = "" {
        didSet {
            if (commentsCount != oldValue) {
                commentsCountLabel.text = commentsCount
            }
        }
    }
    
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postContentView: UIView!
    @IBOutlet weak var postDetailsText: UITextView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
