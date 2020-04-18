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
    @IBOutlet weak var TaskType: UILabel!
    @IBOutlet weak var TaskDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tasks.taskname
        labelInit()
    }
    
    
    func labelInit(){
        TaskDueDate.attributedText = attributedText(withString: "Due Date: \(tasks.taskdueDate)", boldString: "Due Date:", font: TaskDueDate.font)
        TaskType.attributedText = attributedText(withString: "Status: \(tasks.tasktype)", boldString: "Status:", font: TaskType.font)
        TaskDescription.attributedText = attributedText(withString: "Description: \(tasks.taskdescription)", boldString: "Description", font: TaskDescription.font)
    }

}
