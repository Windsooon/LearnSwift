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
                postDetailsLabel.text = postDetails
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
    
    var likesCount: Int = 0 {
        didSet {
            if (likesCount != oldValue) {
                likesCountLabel.text = String(likesCount)
            }
        }
    }
    
    var commentsCount: Int = 0 {
        didSet {
            if (commentsCount != oldValue) {
                commentsCountLabel.text = String(commentsCount)
            }
        }
    }
    
    var postContent: UIView! {
        didSet {
            if (postContent != oldValue) {
                postContentView = postContent
            }
        }
    }
    
    var postHeightLayout: CGFloat! {
        didSet {
            if (postHeightLayout != oldValue) {
                postContentLayoutConstraint.constant = postHeightLayout
            }
        }
    }
    
    
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postContentView: UIView!
    @IBOutlet weak var postDetailsLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var postContentLayoutConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
