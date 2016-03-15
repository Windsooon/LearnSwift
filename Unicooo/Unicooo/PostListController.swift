//
//  PostListController.swift
//  Unicooo
//
//  Created by Windson on 16/1/30.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation


class PostListController: UICollectionViewController {
    private let reuseIdentifier = "Cell"
    var postPhotos = NSMutableOrderedSet()
    var requestingPostList = false
    var currentPage = 1
    var actId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? PostListLayout {
            layout.delegate = self
        }
        requestPostList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)
        let postDetails = segue.destinationViewController as! PostDetailsController
        let postPhotosInfo = (postPhotos.objectAtIndex(indexPath!.row) as! PostPhotoInfo)
        postDetails.postId = postPhotosInfo.id
        postDetails.postAuthor = postPhotosInfo.author
        postDetails.postUrl = postPhotosInfo.url
        postDetails.postRadio = (postPhotosInfo.width)/(postPhotosInfo.height)
        postDetails.postPosttime = postPhotosInfo.createTime
        postDetails.postContent = postPhotosInfo.content
    }

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
        
        let postInfo = postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo
        let imageURL = postInfo.url
        cell.postContent = postInfo.content
        cell.postAuthor = postInfo.author
        cell.postTime = postInfo.createTime
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
        
        Alamofire.request(Unicooo.Router.ReadPostList(["act_id": self.actId, "page": self.currentPage])).validate().responseJSON {
            response in
            switch response.result {
            case .Success:
                let JSON = response.result.value
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let photoInfos =  ((JSON as! NSDictionary).valueForKey("results") as! [NSDictionary]).map {
                        PostPhotoInfo(
                            id: ($0["id"] as! Int),
                            url: httpsUrl + ($0["post_thumb_url"] as! String) + postList,
                            title: ($0["post_title"] as! String),
                            content: ($0["post_content"] as! String),
                            author: ($0["post_user"]!["user_name"] as! String),
                            createTime: ($0["post_create_time"] as! String),
                            width: ($0["post_thumb_width"] as! CGFloat),
                            height: ($0["post_thumb_height"] as! CGFloat))
                    }
                    
                    let lastItem = self.postPhotos.count
                    self.postPhotos.addObjectsFromArray(photoInfos)
                    let indexPaths = (lastItem..<self.postPhotos.count).map { NSIndexPath(forItem: $0, inSection: 0)}
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                    }
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

extension PostListController : PostListLayoutDelegate {
    // 1
    //func postListLayout(postListLayout: PostListLayout, heightForPhotoWidth: CGFloat,atIndexPath: NSIndexPath) -> CGFloat {
    //    return CGFloat(100)
    //}
    //
    //func postListLayout(postListLayout: PostListLayout, heightForContentWidth: CGFloat,atIndexPath: NSIndexPath) -> CGFloat {
    //    return CGFloat(100)
    //}
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
        withWidth width: CGFloat) -> CGFloat {
            let postInfo = postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo
            let photoHeight = postInfo.height
            let photoWidth = postInfo.width
            let postReturnHeight = photoHeight * width/photoWidth
            return postReturnHeight
    }
    
    // 2
    func collectionView(collectionView: UICollectionView,
        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let annotationPadding = CGFloat(4)
            let annotationHeaderHeight = CGFloat(17)
            let photo = (postPhotos.objectAtIndex(indexPath.row) as! PostPhotoInfo)
            let font = UIFont(name: "AvenirNext-Regular", size: 10)!
            let contentHeight = photo.heightForContent(font, width: width)
            let height = annotationPadding + annotationHeaderHeight + contentHeight + annotationPadding
            return height
    }
}

