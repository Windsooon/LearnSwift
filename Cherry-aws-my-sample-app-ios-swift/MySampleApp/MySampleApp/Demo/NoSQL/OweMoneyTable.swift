
import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class OweMoneyTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var partitionKeyType: String
    var sortKeyName: String?
    var sortKeyType: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {
        
        return "OweMoney"
    }
    
    override init() {
        
        model = OweMoney()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        partitionKeyType = "String"
        indexes = [
            
            OweMoneyPrimaryIndex(),
            
            OweMoneyStatus(),
            
            OweMoneyOtherUser(),
        ]
        if (model.classForCoder.respondsToSelector("rangeKeyAttribute")) {
            sortKeyName = model.classForCoder.rangeKeyAttribute!()
            sortKeyType = "String"
        }
        super.init()
    }
    
    
    func tableAttributeName(dataObjectAttributeName: String) -> String {
        return OweMoney.JSONKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    
    func insertDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        var errors: [NSError] = []
        let group: dispatch_group_t = dispatch_group_create()
        
        let itemForGet = OweMoney()
        
        itemForGet._userId = AWSIdentityManager.defaultIdentityManager().identityId!
        itemForGet._createdDate = "demo-createdDate-500000"
        itemForGet._money = 1
        itemForGet._otherUserFacebookId = "1"
        itemForGet._otherUserId = "1"
        itemForGet._status = 1
        itemForGet._updatedDate = "1"
        
        dispatch_group_enter(group)
        
        
        objectMapper.save(itemForGet, completionHandler: {(error: NSError?) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    errors.append(error!)
                })
            }
            dispatch_group_leave(group)
        })
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            if errors.count > 0 {
                completionHandler(errors: errors)
            }
            else {
                completionHandler(errors: nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(completionHandler: (errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]
        
        objectMapper.query(OweMoney.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(errors: [error]);
                })
            } else {
                var errors: [NSError] = []
                let group: dispatch_group_t = dispatch_group_create()
                for item in response!.items {
                    dispatch_group_enter(group)
                    objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
                        if error != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                errors.append(error!)
                            })
                        }
                        dispatch_group_leave(group)
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), {
                    if errors.count > 0 {
                        completionHandler(errors: errors)
                    }
                    else {
                        completionHandler(errors: nil)
                    }
                })
            }
        }
    }
    
    func updateItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        
        let itemToUpdate: OweMoney = item as! OweMoney
        
        itemToUpdate._money = 123
        itemToUpdate._otherUserFacebookId = "1"
        itemToUpdate._otherUserId = "12"
        itemToUpdate._status = 1
        itemToUpdate._updatedDate = "1"
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
    
    func removeItem(item: AWSDynamoDBObjectModel, completionHandler: (error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        
        objectMapper.remove(item, completionHandler: {(error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(error: error)
            })
        })
    }
}

class OweMoneyPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and money > \(1111500000)."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#money > :money"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#money": "money",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":money": 1111500000,
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and createdDate < \("demo-createdDate-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #createdDate < :createdDate"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#createdDate": "createdDate",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":createdDate": "demo-createdDate-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!), createdDate < \("demo-createdDate-500000"), and money > \(1111500000)."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #createdDate < :createdDate"
        queryExpression.filterExpression = "#money > :money"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#createdDate": "createdDate",
            "#money": "money",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":createdDate": "demo-createdDate-500000",
            ":money": 1111500000,
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}

class OweMoneyStatus: NSObject, Index {
    
    var indexName: String? {
        
        return "status"
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "status"
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and createdDate > \("demo-createdDate-500000")."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "status"
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#createdDate > :createdDate"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#createdDate": "createdDate",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":createdDate": "demo-createdDate-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and status < \(1111500000)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "status"
        queryExpression.keyConditionExpression = "#userId = :userId AND #status < :status"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#status": "status",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":status": 1111500000,
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!), status < \(1111500000), and createdDate > \("demo-createdDate-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "status"
        queryExpression.keyConditionExpression = "#userId = :userId AND #status < :status"
        queryExpression.filterExpression = "#createdDate > :createdDate"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#status": "status",
            "#createdDate": "createdDate",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":status": 1111500000,
            ":createdDate": "demo-createdDate-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}

class OweMoneyOtherUser: NSObject, Index {
    
    var indexName: String? {
        
        return "otherUser"
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "otherUser"
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.defaultIdentityManager().identityId!,]
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and createdDate > \("demo-createdDate-500000")."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "otherUser"
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#createdDate > :createdDate"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#createdDate": "createdDate",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":createdDate": "demo-createdDate-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!) and otherUserId < \("demo-otherUserId-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "otherUser"
        queryExpression.keyConditionExpression = "#userId = :userId AND #otherUserId < :otherUserId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#otherUserId": "otherUserId",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":otherUserId": "demo-otherUserId-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        return "Find all items with userId = \(AWSIdentityManager.defaultIdentityManager().identityId!), otherUserId < \("demo-otherUserId-500000"), and createdDate > \("demo-createdDate-500000")."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(completionHandler: (response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        
        queryExpression.indexName = "otherUser"
        queryExpression.keyConditionExpression = "#userId = :userId AND #otherUserId < :otherUserId"
        queryExpression.filterExpression = "#createdDate > :createdDate"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#otherUserId": "otherUserId",
            "#createdDate": "createdDate",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.defaultIdentityManager().identityId!,
            ":otherUserId": "demo-otherUserId-500000",
            ":createdDate": "demo-createdDate-500000",
        ]
        
        
        objectMapper.query(OweMoney.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(response: response, error: error)
            })
        })
    }
}
