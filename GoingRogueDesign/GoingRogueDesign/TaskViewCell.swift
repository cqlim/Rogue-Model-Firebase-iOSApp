//
//  TaskViewCell.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/4/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var resolvedButton: UIButton!
    
    func setTask(task: Task){
        
        taskName.text = task.taskname
        
        // remove the time when displaying the due date in the task list view
        var str = task.taskdueDate
        if let dueDateRange = task.taskdueDate.range(of: " at"){
            str.removeSubrange(dueDateRange.lowerBound..<str.endIndex)
        }
        taskDueDate.text = str
    }
    
    // Sets the resolve button's state when launch the task view
    func resolvedButtonStatus(status: String){
        if(status == "completed"){
            resolvedButton.isSelected = true
        }
        else{
            resolvedButton.isSelected = false
        }
    }
    
}
