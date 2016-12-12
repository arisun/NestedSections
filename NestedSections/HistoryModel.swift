//
//  HistoryModel.swift
//  NestedSections
//
//  Created by arindam_ghosh on 12/10/16.
//  Copyright © 2016 arindam_ghosh. All rights reserved.
//

import UIKit

class HistoryModel: NSObject {
    
    var financialAsAtDate: String?
    var opStatus: String?
    var nextStartKey: String?
    var transactions : [TransactionModel]?
    
    override init() {
        //transactions = [TransactionModel(),TransactionModel()]
        //transactions = []

    }
    

}

class TransactionModel: NSObject {
    var dateStr: String = ""
    var typeArray : [TransactionModelDetails]?
    
    override init() {
        dateStr = ""
        //typeArray = [TransactionModelDetails(),TransactionModelDetails()]
        typeArray = []

    }
}

class TransactionModelDetails: NSObject {
    var typeStr: String = ""
    var productTypeStr: String = ""
    var activityArray = [ActivityModel]()
    override init() {
        typeStr = ""
        //activityArray = [ActivityModel(),ActivityModel(),ActivityModel()]
        activityArray = []

    }
}

class ActivityModel: NSObject {
    
    var amount: String = ""
    var descriptionLine1: String = ""
    var descriptionLine2: String = ""
}


