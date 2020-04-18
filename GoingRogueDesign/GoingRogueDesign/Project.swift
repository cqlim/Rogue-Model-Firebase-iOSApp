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
    var id: String
    var description: String
    
    // The Firebase floating point is 64 bit
    var longitude: Float64
    var latitude: Float64
    
    var manager: String
    var mainContractor: String
        
    init(title: String, address: String, status: String, startDate: String, description: String, id: String, longitude: Float64, latitude: Float64, manager: String, mainContractor: String) {
        self.id = id
        self.title = title
        self.address = address
        self.status = status
        self.startDate = startDate
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.manager = manager
        self.mainContractor = mainContractor
    }
    
    
}
