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
    

    @IBOutlet weak var postNew: UIScrollView!
    @IBOutlet weak var postNewImageView: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var postBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboard()
        hideTap()
        setTextBorder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func setTextBorder() {
        postContent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        postContent.layer.borderWidth = 1.0;
        postContent.layer.cornerRadius = 5.0;
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
    
    func hideTap() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostNewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        postNew.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        postContent.resignFirstResponder()
    }
    
    func registerKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostNewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize:CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height,  0.0);
                self.postNew.contentInset = contentInset
                self.postNew.scrollIndicatorInsets = contentInset
                self.postNew.contentOffset = CGPointMake(self.postNew.contentOffset.x, 0 + keyboardSize.height)
            }
        }
        //adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            if let _:CGSize =  userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size {
                let contentInset = UIEdgeInsetsZero;
                self.postNew.contentInset = contentInset
                self.postNew.scrollIndicatorInsets = contentInset
                self.postNew.contentOffset = CGPointMake(self.postNew.contentOffset.x, self.postNew.contentOffset.y)
            }
        }
        //adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 40) * (show ? 1 : -1)
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.postNew.contentInset.bottom += changeInHeight
            self.postNew.scrollIndicatorInsets.bottom += changeInHeight
        })
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
