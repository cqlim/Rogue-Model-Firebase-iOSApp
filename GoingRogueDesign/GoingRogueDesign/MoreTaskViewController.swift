//
//  MoreTaskViewController.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/4/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class MoreTaskViewController: UIViewController {

    var tasks: Task!

    @IBOutlet weak var TaskDueDate: UILabel!
    @IBOutlet weak var TaskStatus: UILabel!
    @IBOutlet weak var TaskDescription: UILabel!
    @IBOutlet weak var TaskResolvedDate: UILabel!
    @IBOutlet weak var TaskName: UILabel!
//    var taskDueDateAttributedString = NSAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelInit()
    }
    
    
    func labelInit(){
        
//        // red due date will showed up in the task detail if it's overdue
//        let dueDateTitle_MutableAS = attributedText(withString: "Due Date: ", boldString: "Due Date:", font: TaskDueDate.font).mutableCopy() as! NSMutableAttributedString
//        dueDateTitle_MutableAS.append(taskDueDateAttributedString)
//        TaskDueDate.attributedText = dueDateTitle_MutableAS
        
        TaskDueDate.attributedText = attributedText(withString: "Due Date: \(tasks.taskDueDate)", boldString: "Due Date:", font: TaskDueDate.font)

        TaskStatus.attributedText = attributedText(withString: "Status: \(tasks.taskStatus)", boldString: "Status:", font: TaskStatus.font)
        TaskDescription.attributedText = attributedText(withString: "Description: \(tasks.taskDescription)", boldString: "Description", font: TaskDescription.font)
        
        TaskName.attributedText = attributedText(withString: "Name: \(tasks.taskName)", boldString: "Name:", font: TaskName.font)
        
        TaskResolvedDate.attributedText = attributedText(withString: "Resolved Date: \(tasks.taskResolvedDate)", boldString: "Resolved Date:", font: TaskResolvedDate.font)
    }

}
