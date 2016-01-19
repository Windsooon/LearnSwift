//
//  extendForNextField.swift
//  Unicooo
//
//  Created by Windson on 16/1/16.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

private var kAssociationKeyNextField: UInt8 = 0

extension UITextField {
    var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}