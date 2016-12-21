//
//  LendMoney.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.8
//

import Foundation
import UIKit
import AWSDynamoDB

class LendMoney: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _createdDate: String?
    var _money: NSNumber?
    var _otherUserFacebookId: String?
    var _otherUserId: String?
    var _status: NSNumber?
    var _updatedDate: String?
    
    class func dynamoDBTableName() -> String {
        
        return "cherry-mobilehub-1605355483-lendMoney"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_createdDate"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
            "_userId" : "userId",
            "_createdDate" : "createdDate",
            "_money" : "money",
            "_otherUserFacebookId" : "otherUserFacebookId",
            "_otherUserId" : "otherUserId",
            "_status" : "status",
            "_updatedDate" : "updatedDate",
        ]
    }
}