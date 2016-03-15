  //
//  PostListCell.swift
//  Unicooo
//
//  Created by Windson on 16/1/30.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire

class PostListCell: UICollectionViewCell {
    var request: Alamofire.Request?
    
    @IBOutlet weak var imageViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    var postAuthor: String = "" {
        didSet {
            if (postAuthor != oldValue) {
                postAuthorLabel.text = postAuthor
            }
        }
    }
    
    var postTime: String = "" {
        didSet {
            if (postTime != oldValue) {
                postTimeLabel.text = postTime
            }
        }
    }
    
    var postContent: String = "" {
        didSet {
            if (postContent != oldValue) {
                postContentLabel.text = postContent
            }
        }
    }
    
    var postThumb: UIImage! {
        didSet {
            if (postThumb != oldValue) {
                postImageView.image = postThumb
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PostListLayoutAttributes {
            imageViewLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
