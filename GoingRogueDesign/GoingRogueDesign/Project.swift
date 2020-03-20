//
//  Project.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 2/19/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Project {
    var title: String
    var address: String
    var status: String
    var startDate: String
//    var startDate: Date
    var description: String
    
//    var date = Date()
    
    init(title: String, address: String, status: String, startDate: String, description: String) {
        self.title = title
        self.address = address
        self.status = status
        self.startDate = startDate
        self.description = description
    }
    
    
}
