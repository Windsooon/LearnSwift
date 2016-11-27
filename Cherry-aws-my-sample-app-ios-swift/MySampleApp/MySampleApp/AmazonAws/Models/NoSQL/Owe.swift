//
//  Owe.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.6
//

import Foundation
import UIKit
import AWSDynamoDB

class Owe: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _createDate: NSNumber?
    var _money: NSNumber?
    var _otherUser: String?
    var _status: NSNumber?
    var _updateDate: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "cherry-mobilehub-1605355483-owe"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_createDate"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
               "_userId" : "userId",
               "_createDate" : "createDate",
               "_money" : "money",
               "_otherUser" : "otherUser",
               "_status" : "status",
               "_updateDate" : "updateDate",
        ]
    }
}
