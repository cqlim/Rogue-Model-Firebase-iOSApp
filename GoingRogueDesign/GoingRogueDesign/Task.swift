//
//  Task.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/2/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Task {
    var taskname: String
    var tasktype: String
    var taskdueDate: String
    var taskdescription: String
    

    init(name: String, type: String, dueDate: String, description: String) {
        self.taskname = name
        self.tasktype = type
        self.taskdueDate = dueDate
        self.taskdescription = description
    }

}

