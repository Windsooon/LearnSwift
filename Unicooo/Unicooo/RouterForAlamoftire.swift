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
