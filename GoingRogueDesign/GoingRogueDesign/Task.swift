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
    var taskStatus: String
    var taskdueDate: String
    var taskdescription: String
    var taskResolvedDate: String
    

    init(name: String, status: String, dueDate: String, description: String, resolvedDate: String) {
        self.taskname = name
        self.taskStatus = status
        self.taskdueDate = dueDate
        self.taskdescription = description
        self.taskResolvedDate = resolvedDate
    }

}

