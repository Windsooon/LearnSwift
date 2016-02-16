//
//  PostListController.swift
//  Unicooo
//
//  Created by Windson on 16/1/30.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire


class PostListController: UICollectionViewController {
    private let reuseIdentifier = "Cell"
    //var postPhotos = NSMutableOrderedSet()
    var postPhotos = NSMutableOrderedSet()
    var requestingPostList = false
    var currentPage = 1
    var actId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPostList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return postPhotos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PostListCell
        let imageURL = (postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo).url
        cell.postContent = (postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo).content
        cell.postAuthor = (postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo).user
        cell.postTime = (postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo).createTime
        
        cell.request = Alamofire.request(.GET, imageURL).responseImage() {
            response in
            if let image = response.result.value {
                cell.setNeedsLayout()
                cell.postThumb = image
            }
            else {
                print("can't get image")
            }
        }
        
        return cell
    }
    
    func requestPostList() {
        if requestingPostList {
            return
        }
        
        requestingPostList = true
        
        Alamofire.request(Unicooo.Router.ReadPostList("",["act_id": self.actId, "page": self.currentPage])).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                let JSON = response.result.value
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let photoInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                        PostPhotoInfo(id: ($0["id"] as! Int), url: ($0["post_thumb_url"] as! String), title: ($0["post_title"] as! String), content: ($0["post_content"] as! String), author: ($0["post_user"]!["user_name"] as! String), createTime: ($0["post_create_time"] as! String))
                    }
                    
                    let lastItem = self.postPhotos.count
                    
                    self.postPhotos.addObjectsFromArray(photoInfos)
                    
                    let indexPaths = (lastItem..<self.postPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                    
                    //dispatch_async(dispatch_get_main_queue()) {
                    //    self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                    //}
                    self.currentPage++
                }
                self.requestingPostList = false
            case .Failure(let error):
                print(error)
            }
        }
        // Notify that we are no longer populating photos
    }
    // MARK: UICollectionViewDelegate
}

extension PostListController : GridLayoutDelegate {
    // 1
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let photo = photos[indexPath.item]
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
            return rect.size.height
    }
    
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let annotationPadding = CGFloat(4)
            let annotationHeaderHeight = CGFloat(17)
            let photo = photos[indexPath.item]
            let font = UIFont(name: "AvenirNext-Regular", size: 10)!
            let commentHeight = photo.heightForComment(font, width: width)
            let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
            return height
    }
}

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

