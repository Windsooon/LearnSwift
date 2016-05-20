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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        performSegueWithIdentifier("PostDetailsIdentifier", sender: cell )
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)
        let postDetails = segue.destinationViewController as! PostDetailsViewController
        let postPhotosInfo = (postPhotos.objectAtIndex(indexPath!.row) as! PostPhotoInfo)
        
        postDetails.postId = postPhotosInfo.id
        postDetails.postAuthor = postPhotosInfo.author
        postDetails.postCommentsCount = postPhotosInfo.comment_count
        postDetails.postLikes = postPhotosInfo.likes
        postDetails.postMime = postPhotosInfo.mime_types
        postDetails.postUrl = httpsUrl + postPhotosInfo.url + postList
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
        let imageURL = httpsUrl + postInfo.url + postList
        cell.postContent = postInfo.content
        cell.postAuthor = postInfo.author
        cell.postTime = postInfo.createTime
        cell.postThumb = nil
        cell.request?.cancel()
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
                            url: ($0["post_thumb_url"] as! String),
                            title: ($0["post_title"] as! String),
                            content: ($0["post_content"] as! String),
                            author: ($0["post_user"]!["user_name"] as! String),
                            comment_count: ($0["comment_count"] as! Int),
                            likes: ($0["likes"] as! Int),
                            mime_types: ($0["post_mime_types"] as! Int),
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
                    self.currentPage += 1
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

