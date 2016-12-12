//
//  HistoryMapper.swift
//  NestedSections
//
//  Created by arindam_ghosh on 12/10/16.
//  Copyright © 2016 arindam_ghosh. All rights reserved.
//

import UIKit
import ObjectMapper

class HistoryMapper: Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        mapping(map: map)
    }


    
    var financialAsAtDate: String?
    var opStatus: String?
    var nextStartKey: String?
    var transactionsByDate: [HistoryDateMapper]?
    


    // Mappable
    func mapping(map: Map) {
        financialAsAtDate         <- map["financialAsAtDate"]
        opStatus      <- map["opStatus"]
        nextStartKey       <- map["nextStartKey"]
        transactionsByDate  <- map["transactionsByDate"]
        
    }
}

class HistoryDateMapper: Mappable {
    
    var dateOfTransaction: String?
    var product: [HistoryProductMapper]?
    
    required init?(map: Map) {
        mapping(map: map)

    }

    
    // Mappable
    func mapping(map: Map) {
        dateOfTransaction    <- map["dateOfTransaction"]
        product         <- map["product"]
        
    }
}

class HistoryProductMapper: Mappable {
    
    var productType: String?
    var activity: [HistoryActivityMapper]?
    
    required init?(map: Map) {
        mapping(map: map)

    }

    
    // Mappable
    func mapping(map: Map) {
        productType    <- map["productType"]
        activity         <- map["activity"]
        
    }
}


class HistoryActivityMapper: Mappable {
    
    var amount: String?
    var activityLine2: String?
    var descriptionLine1: String?
    var descriptionLine2: String?
    
    required init?(map: Map) {
        mapping(map: map)

    }

    
    // Mappable
    func mapping(map: Map) {
        amount    <- map["amount"]
        activityLine2   <- map["activityLine2"]
        descriptionLine1  <- map["descriptionLine1"]
        descriptionLine2  <- map["descriptionLine2"]

        
    }
}
