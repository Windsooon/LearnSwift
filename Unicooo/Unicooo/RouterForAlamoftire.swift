//
//  Five100px.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}
extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T,NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T,NSError> {
            request, response, data, error in
            
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response, JSON = T(response: response, representation: value) {
                    return .Success(JSON)
                } else {
                    let failureReason = "JSON could not be serialized into response object \(value)"
                    let error =  Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
                
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension Alamofire.Request {
    public static func imageResponseSerializer() -> ResponseSerializer<UIImage, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else { return .Failure(error!)}
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil"
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            guard let image = UIImage(data: validData, scale: UIScreen.mainScreen().scale) else {
                let failureReason = "Data could not be converted to UIImage"
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            return .Success(image)
        }
    }
    public func responseImage(completionHandler: Response<UIImage, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}


struct Unicooo {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://127.0.0.1:8000/api"
        static var OAuthToken: String?
        
        case CreateUser([String: AnyObject])
        
        case CreateAct([String: AnyObject])
        case ReadActList([String: AnyObject]?)
        case UpdateAct(String, [String: AnyObject])
        case DestroyAct(String)
        
        case CreatePost([String: AnyObject])
        case ReadPostList([String: AnyObject]?)
        case UpdatePost(String, [String: AnyObject])
        case DestroyPost(String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateUser, .CreateAct, .CreatePost:
                return .POST
            case .ReadActList, .ReadPostList:
                return .GET
            case .UpdateAct, .UpdatePost:
                return .PUT
            case .DestroyAct, .DestroyPost:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            //RESTAPI for user
            case .CreateUser:
                return "/users"
            //RESTAPI for act
            case .CreateAct:
                return "/acts"
            case .ReadActList:
                return "/acts/"
            case .UpdateAct(let actId, _):
                return "/acts/\(actId)"
            case .DestroyAct(let actId):
                return "/acts/\(actId)"
            //RESTAPI for post
            case .CreatePost:
                return "/posts"
            case .ReadPostList:
                return "/posts/"
            case .UpdatePost(let postId, _):
                return "/posts/\(postId)"
            case .DestroyPost(let postId):
                return "/posts/\(postId)"
            }
        }
        
        // MARK: URLRequestConvertible
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            switch self {
            //for user
            case .CreateUser(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            //for act
            case .CreateAct(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadActList(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateAct(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            //for post
            case .CreatePost(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadPostList(let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdatePost(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }
}

class ActPhotoInfo: NSObject {
    let id: Int
    let url: String
    let title: String
    let content: String
    let user: String
    let createTime: String
    
    init(id: Int, url: String, title: String, content: String, author: String, createTime: String) {
        self.id = id
        self.url = url
        self.title = title
        self.content = content
        self.user = author
        self.createTime = createTime
    }
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("actPhotoInfo.id") as! Int
        self.url = representation.valueForKeyPath("actPhotoInfo.act_thumb_url") as! String
        self.title = representation.valueForKeyPath("actPhotoInfo.act_title") as! String
        self.content = representation.valueForKeyPath("actPhotoInfo.act_content") as! String
        self.user = representation.valueForKeyPath("actPhotoInfo.user") as! String
        self.createTime = representation.valueForKeyPath("actPhotoInfo.act_create_time") as! String
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! ActPhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as ActPhotoInfo).id
    }
}

class PostPhotoInfo: NSObject {
    let id: Int
    let url: String
    let title: String
    let content: String
    let author: String
    let createTime: String
    let width: CGFloat
    let height: CGFloat
    
    init(id: Int, url: String, title: String, content: String, author: String, createTime: String, width: CGFloat, height: CGFloat) {
        self.id = id
        self.url = url
        self.title = title
        self.content = content
        self.author = author
        self.createTime = createTime
        self.width = width
        self.height = height
    }
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("postPhotoInfo.id") as! Int
        self.url = representation.valueForKeyPath("postPhotoInfo.post_thumb_url") as! String
        self.title = representation.valueForKeyPath("postPhotoInfo.postt_title") as! String
        self.content = representation.valueForKeyPath("postPhotoInfo.post_content") as! String
        self.author = representation.valueForKeyPath("postPhotoInfo.post_user.user_name") as! String
        self.createTime = representation.valueForKeyPath("postPhotoInfo.post_create_time") as! String
        self.width = representation.valueForKeyPath("postPhotoInfo.post_thumb_width") as! CGFloat
        self.height = representation.valueForKeyPath("postPhotoInfo.post_thumb_height") as! CGFloat
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! PostPhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as PostPhotoInfo).id
    }
    
    func heightForContent(font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = NSString(string: content).boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}


