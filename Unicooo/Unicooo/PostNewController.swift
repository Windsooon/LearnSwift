//
//  PostNewController.swift
//  Unicooo
//
//  Created by Windson on 16/6/4.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class PostNewController: UIViewController {
    
    var postNewImage: UIImage?
    var postNewNSURL: NSURL?
    var postNewLastChosenMediaType: String?
    var moviePlayerController:MPMoviePlayerController?
    

    @IBOutlet weak var postNewImageView: UIImageView!
    @IBOutlet weak var postNewContent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDisplay() {
        if let mediaType = postNewLastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                postNewImageView.image = postNewImage!
                postNewImageView.hidden = false
                if moviePlayerController != nil {
                    moviePlayerController!.view.hidden = true
                }
            }
            else if mediaType == kUTTypeMovie as NSString {
                if moviePlayerController == nil {
                    moviePlayerController = MPMoviePlayerController(contentURL: postNewNSURL)
                    let movieView = moviePlayerController!.view
                    movieView.frame = postNewImageView.frame
                    movieView.clipsToBounds = true
                    view.addSubview(movieView)
                    setMoviePlayerLayoutConstraints()
                } else {
                    moviePlayerController!.contentURL = postNewNSURL
                }
                postNewImageView.hidden = true
                moviePlayerController!.view.hidden = false
                moviePlayerController!.play()
            }
        }
    }
    
    func setMoviePlayerLayoutConstraints() {
        //let moviePlayerView = moviePlayerController!.view
        //moviePlayerView.translatesAutoresizingMaskIntoConstraints = false
        //let views = ["moviePlayerView": moviePlayerView, "takePictureButton": takePictureButton]
        //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        //    "H:|[moviePlayerView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:views))
        //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        //    "V:|[moviePlayerView]-0-[takePictureButton]", options:NSLayoutFormatOptions(rawValue: 0),
        //    metrics:nil, views:views))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
