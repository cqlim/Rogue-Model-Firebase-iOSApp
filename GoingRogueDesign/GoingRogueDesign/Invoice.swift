//
//  File.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 3/30/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Invoice{
    var dueDate: String
    var url: String
    var name: String
    var paid: String
    var projectID: String
    var invoiceID: String
    var dueDateForChecking: Date
    var paidDate: String
    
    
    init(dueDate: String, url: String, name: String, paid: String, projectID: String, invoiceID: String, dueDateForChecking: Date, paidDate: String) {
        self.dueDate = dueDate
        self.url = url
        self.name = name
        self.paid = paid
        self.projectID = projectID
        self.invoiceID = invoiceID
        self.dueDateForChecking = dueDateForChecking
        self.paidDate = paidDate
    }
}
