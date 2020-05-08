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
    
    func setTask(task: Task){
        
        taskName.text = task.taskname
        taskDueDate.text = task.taskdueDate
    }
}
