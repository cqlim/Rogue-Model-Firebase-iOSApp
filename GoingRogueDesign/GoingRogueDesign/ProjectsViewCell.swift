//
//  ProjectViewCell.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 2/19/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class ProjectsViewCell: UITableViewCell {
    
    @IBOutlet weak var projectTitle: UILabel!
    
    func setProject(project: Project){
        
        projectTitle.text = project.title
    }
    

}
