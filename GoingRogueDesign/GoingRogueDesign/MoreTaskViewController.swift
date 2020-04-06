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
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = tasks.taskname
        taskType.text = tasks.tasktype
        taskDescription.text = tasks.taskdescription
        taskDueDate.text = tasks.taskdueDate
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
