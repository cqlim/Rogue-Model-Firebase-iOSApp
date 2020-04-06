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
    var type: String
    var projectID: String
    
//    var date = Date()
    
    init(dueDate: String, url: String, name: String, type: String, projectID: String) {
        self.dueDate = dueDate
        self.url = url
        self.name = name
        self.type = type
        self.projectID = projectID
    }
}
