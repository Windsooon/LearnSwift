//
//  Five100px.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

extension Alamofire.Request {
    
    /** Response serializer for images from: http://www.raywenderlich.com/85080/beginning-alamofire-tutorial */
    public static func imageResponseSerializer() -> ResponseSerializer<UIImage, NSError> {
        return ResponseSerializer { request, response, data, error in
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            if let image = UIImage(data: validData, scale: UIScreen.mainScreen().scale) {
                return .Success(image)
            }
            else {
                return .Failure(Error.errorWithCode(.DataSerializationFailed, failureReason: "Unable to create image."))
            }
            
        }
    }
    
    /** Convenience method for returning images from: http://www.raywenderlich.com/85080/beginning-alamofire-tutorial */
    func responseImage(completionHandler: Response<UIImage, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}

struct Five100px {
  enum Router: URLRequestConvertible {
    static let baseURLString = "https://api.500px.com/v1"
    static let consumerKey = "ImOLbXsCkxN2L8WEttDV3ptaqQqUDYrqR1uHItWT"
    
    case PopularPhotos(Int)
    case PhotoInfo(Int, ImageSize)
    case Comments(Int, Int)
    
    var URLRequest: NSMutableURLRequest {
      let result: (path: String, parameters: [String: AnyObject]) = {
        switch self {
        case .PopularPhotos (let page):
          let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
          return ("/photos", params)
        case .PhotoInfo(let photoID, let imageSize):
          let params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
          return ("/photos/\(photoID)", params)
        case .Comments(let photoID, let commentsPage):
          let params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
          return ("/photos/\(photoID)/comments", params)
        }
        }()
      
      let URL = NSURL(string: Router.baseURLString)
      let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(result.path))
      let encoding = Alamofire.ParameterEncoding.URL
      
      return encoding.encode(URLRequest, parameters: result.parameters).0
    }
  }
  
  enum ImageSize: Int {
    case Tiny = 1
    case Small = 2
    case Medium = 3
    case Large = 4
    case XLarge = 5
  }
}

class PhotoInfo: NSObject {
  let id: Int
  let url: String
  
  var name: String?
  
  var favoritesCount: Int?
  var votesCount: Int?
  var commentsCount: Int?
  
  var highest: Float?
  var pulse: Float?
  var views: Int?
  var camera: String?
  var desc: String?
  
  init(id: Int, url: String) {
    self.id = id
    self.url = url
  }
  
  required init(response: NSHTTPURLResponse, representation: AnyObject) {
    self.id = representation.valueForKeyPath("photo.id") as! Int
    self.url = representation.valueForKeyPath("photo.image_url") as! String
    
    self.favoritesCount = representation.valueForKeyPath("photo.favorites_count") as? Int
    self.votesCount = representation.valueForKeyPath("photo.votes_count") as? Int
    self.commentsCount = representation.valueForKeyPath("photo.comments_count") as? Int
    self.highest = representation.valueForKeyPath("photo.highest_rating") as? Float
    self.pulse = representation.valueForKeyPath("photo.rating") as? Float
    self.views = representation.valueForKeyPath("photo.times_viewed") as? Int
    self.camera = representation.valueForKeyPath("photo.camera") as? String
    self.desc = representation.valueForKeyPath("photo.description") as? String
    self.name = representation.valueForKeyPath("photo.name") as? String
  }
  
  override func isEqual(object: AnyObject!) -> Bool {
    return (object as! PhotoInfo).id == self.id
  }
  
  override var hash: Int {
    return (self as PhotoInfo).id
  }
}

class Comment {
  let userFullname: String
  let userPictureURL: String
  let commentBody: String
  
  init(JSON: AnyObject) {
    userFullname = JSON.valueForKeyPath("user.fullname") as! String
    userPictureURL = JSON.valueForKeyPath("user.userpic_url") as! String
    commentBody = JSON.valueForKeyPath("body") as! String
  }
}