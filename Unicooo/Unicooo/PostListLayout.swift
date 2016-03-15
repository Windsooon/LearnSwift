//
//  PostListLayout.swift
//  Unicooo
//
//  Created by Windson on 16/3/14.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit

protocol PostListLayoutDelegate {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth:CGFloat) -> CGFloat
    // 2. Method to ask the delegate for the height of the annotation text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class PostListLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1
    var photoHeight: CGFloat = 0.0
    
    // 2
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! PostListLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? PostListLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class PostListLayout: UICollectionViewLayout {
    
    // 布局属性
    private var attributes = [PostListLayoutAttributes]()
    
    var delegate: PostListLayoutDelegate!
    
    /// cell margin
    private let cellMargin:CGFloat = 10
    // column count
    private let columnCount = 2
    
    private var currentHeight = ["minHeight": [Float(0.0), 0], "maxHeight": [Float(0.0), 1]]
   
    private var contentHeight: Float  = 0.0
    
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        //attributes.removeAll()
        //heights.removeAll()
        if attributes.isEmpty {
            let count = collectionView!.numberOfItemsInSection(0)
            
            for i in 0 ..< count{
                
                let indexPath = NSIndexPath.init(forItem: i, inSection: 0)
                
                let attribute = layoutAttributesForItemAtIndexPath(indexPath)! as! PostListLayoutAttributes
                
                attributes.append(attribute)
                contentHeight = max(contentHeight, currentHeight["maxHeight"]![0])
                
            }
        }
    }
    
    /**
     
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in attributes {
            if CGRectIntersectsRect(attribute.frame, rect) {
                layoutAttributes.append(attribute)
            }
        }
        return layoutAttributes
    }
    
    /**
   
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = PostListLayoutAttributes.init(forCellWithIndexPath: indexPath)
        
        
        let collectionViewW = collectionView!.frame.size.width
        
        let width = (collectionViewW - (CGFloat(columnCount) + 1) * cellMargin) / CGFloat(columnCount)
        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
            withWidth:width)
        
        let postDetailsHeight = CGFloat(60)
        let annotationHeight = delegate.collectionView(collectionView!,
            heightForAnnotationAtIndexPath: indexPath, withWidth: width)
        let height = photoHeight + postDetailsHeight + annotationHeight
        let minY = currentHeight["minHeight"]
        let maxY = currentHeight["maxHeight"]
        let x = (CGFloat(minY![1]) + 1) * cellMargin + CGFloat(minY![1]) * width
        let y = CGFloat(minY![0]) + cellMargin
        
        if (y + height) > CGFloat(maxY![0]) {
            let columnIndex = currentHeight["minHeight"]![1]
            currentHeight["minHeight"] = currentHeight["maxHeight"]
            currentHeight["maxHeight"] = [Float(y + height), columnIndex]
        }
        else {
            currentHeight["minHeight"]![0] += Float(height + cellMargin)
        }
        
        attribute.photoHeight = photoHeight
        attribute.frame = CGRect(x: x, y: y, width: width, height: CGFloat(height))
        
        return attribute
    }
    
    
    
    override class func layoutAttributesClass() -> AnyClass {
        return PostListLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: CGFloat(contentHeight))
    }
    
}