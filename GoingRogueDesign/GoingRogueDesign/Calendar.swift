//
//  Calendar.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 4/10/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Calendar{
    var link: String
    var name: String
    var projectID: String
    
//    var date = Date()
    
    init(name: String, link: String, projectID: String) {
        self.link = link
        self.name = name
        self.projectID = projectID
    }
}
