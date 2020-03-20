//
//  ProjectDetailViewController.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/6/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    
    @IBOutlet weak var ProjectTitle: UILabel!
    @IBOutlet weak var ProjectAddress: UILabel!
    @IBOutlet weak var ProjectDescription: UILabel!
    @IBOutlet weak var ProjectStatus: UILabel!
    @IBOutlet weak var ProjectStartDate: UILabel!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProjectTitle.text = project.title
        ProjectAddress.text = project.address
        ProjectStatus.text = "Status: " + project.status
        ProjectDescription.text = "Description: " + project.description
        ProjectStartDate.text = "Start Date: " + project.startDate
    }

//    func projectInfoRetrieval() {
//        <#function body#>
//    }
}
