//
//  Five100px.swift
//  Photomania
//
//  Created by Essan Parto on 2014-09-25.
//  Copyright (c) 2014 Essan Parto. All rights reserved.
//

import UIKit
import Alamofire

struct Unicooo {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://127.0.0.1:8000/api"
        static var OAuthToken: String?
        
        case CreateAct([String: AnyObject])
        case ReadActList(String, [String: AnyObject]?)
        case UpdateAct(String, [String: AnyObject])
        case DestroyAct(String)
        
        var method: Alamofire.Method {
            switch self {
            case .CreateAct:
                return .POST
            case .ReadActList:
                return .GET
            case .UpdateAct:
                return .PUT
            case .DestroyAct:
                return .DELETE
            }
        }
        
        var path: String {
            switch self {
            case .CreateAct:
                return "/acts"
            case .ReadActList(let actId, _):
                return "/acts/\(actId)"
            case .UpdateAct(let actId, _):
                return "/acts/\(actId)"
            case .DestroyAct(let actId):
                return "/acts/\(actId)"
            }
        }
        
        // MARK: URLRequestConvertible
        
        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            if let token = Router.OAuthToken {
                mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .CreateAct(let parameters):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            case .ReadActList(_, let parameters):
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .UpdateAct(_, let parameters):
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
    
    //var name: String?
    //
    //var favoritesCount: Int?
    //var votesCount: Int?
    //var commentsCount: Int?
    //
    //var highest: Float?
    //var pulse: Float?
    //var views: Int?
    //var camera: String?
    //var desc: String?
    
    init(id: Int, url: String) {
        self.id = id
        self.url = url
    }
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        self.id = representation.valueForKeyPath("actPhotoInfo.id") as! Int
        self.url = representation.valueForKeyPath("actPhotoInfo.act_thumb_url") as! String
        
        //self.favoritesCount = representation.valueForKeyPath("actPhotoInfo.favorites_count") as? Int
        //self.votesCount = representation.valueForKeyPath("actPhotoInfo.votes_count") as? Int
        //self.commentsCount = representation.valueForKeyPath("actPhotoInfo.comments_count") as? Int
        //self.highest = representation.valueForKeyPath("actPhotoInfo.highest_rating") as? Float
        //self.pulse = representation.valueForKeyPath("actPhotoInfo.rating") as? Float
        //self.views = representation.valueForKeyPath("actPhotoInfo.times_viewed") as? Int
        //self.camera = representation.valueForKeyPath("actPhotoInfo.camera") as? String
        //self.desc = representation.valueForKeyPath("actPhotoInfo.description") as? String
        //self.name = representation.valueForKeyPath("actPhotoInfo.name") as? String
    }
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! ActPhotoInfo).id == self.id
    }
    
    override var hash: Int {
        return (self as ActPhotoInfo).id
    }
}
