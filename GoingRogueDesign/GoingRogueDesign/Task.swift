//
//  Task.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/2/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Task {
    var taskName: String
    var taskStatus: String
    var taskDueDate: String
    var taskDescription: String
    var taskResolvedDate: String
    var taskID: String
    var taskOverdue: Date
    

    init(name: String, status: String, dueDate: String, description: String, resolvedDate: String, id: String, overdue: Date) {
        self.taskName = name
        self.taskStatus = status
        self.taskDueDate = dueDate
        self.taskDescription = description
        self.taskResolvedDate = resolvedDate
        self.taskID = id
        self.taskOverdue = overdue
    }

}

