//
//  RoundedCornersView.swift
//  Unicooo
//
//  Created by Windson on 16/2/3.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}