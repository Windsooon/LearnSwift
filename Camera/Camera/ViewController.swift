//
//  ViewController.swift
//  Camera
//
//  Created by Windson on 16/1/22.
//  Copyright © 2016年 Windson. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var takePictureButton: UIButton!
    var moviePlayerController: MPMoviePlayerController?
    var image: UIImage?
    var movieURL: NSURL?
    var lastChosenMediaType: String?
    
    @IBAction func shootPictureOrVideo(sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func selectExistingPictureOrVideo(sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            takePictureButton.hidden = true
        }
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
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                imageView.image = image!
                imageView.hidden = false
                if moviePlayerController != nil {
                    moviePlayerController!.view.hidden = true
                }
            }
            else if mediaType == kUTTypeMovie as NSString {
                if moviePlayerController == nil {
                    moviePlayerController = MPMoviePlayerController(contentURL: movieURL)
                    let movieView = moviePlayerController!.view
                    movieView.frame = imageView.frame
                    movieView.clipsToBounds = true
                    view.addSubview(movieView)
                    setMoviePlayerLayoutConstraints()
                }
                else {
                    moviePlayerController!.contentURL = movieURL
                }
            }
        }
    }
    
    func setMoviePlayerLayoutConstraints() {
        let moviePlayerView = moviePlayerController!.view
        moviePlayerView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["moviePlayerView": moviePlayerView,
                     "takePictureButton": takePictureButton]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[moviePlayerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[moviePlayerView]-0-[takePictureButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }

    func pickMediaFromSource(sourceType: UIImagePickerControllerSourceType) {
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType) && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Error accessing media", message: "Unsupported media source", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            }
            else if mediaType == kUTTypeMovie as NSString {
                movieURL = info[UIImagePickerControllerMediaURL] as? NSURL
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

