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
    
    // Sets the task labels
    func setTask(task: Task, dueDate: NSAttributedString){
        
        taskName.text = task.taskName
        
        // remove the time when displaying the due date in the task list view
        let str = dueDate.mutableCopy() as! NSMutableAttributedString
        guard let range = str.string.range(of: " at") else{
            print("Task's dueDate Timestamp has wrongly parsed, with no 'at'")
            return;
        }
        
        // removing substring after 'at'
        let nsRange = NSRange(range.lowerBound..<str.string.endIndex, in: str.string)
        str.replaceCharacters(in: nsRange, with: "")
    
        taskDueDate.attributedText = str
    }
    
    // Sets the resolve button's state when launch the task view
    func resolvedButtonStatus(task: Task){
        if(task.taskStatus == "completed"){
            resolvedButton.isSelected = true
        }
        else{
            resolvedButton.isSelected = false
        }
    }
    
    // use a red-colored string if it's not resolved and past the due date
    func checkOverdue(task: Task) -> NSAttributedString{
        let currentDateTime = Date()
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        
        attributes[.foregroundColor] = UIColor.red

        var attributedString = NSAttributedString(string: task.taskDueDate)

        if((currentDateTime > task.taskOverdue) && (task.taskStatus != "completed") ){

            attributedString = NSAttributedString(string: task.taskDueDate, attributes: attributes)

        }
        
        
        return attributedString
    }
    
}
