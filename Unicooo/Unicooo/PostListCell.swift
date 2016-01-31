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
    
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    
}
