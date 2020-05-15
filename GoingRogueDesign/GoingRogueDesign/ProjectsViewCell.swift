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
    
    // sets the text colors for project status
    private func setAccessoryStatusColor(status: String, color: UIColor) -> NSAttributedString{
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = color

        let attributedString = NSAttributedString(string: status, attributes: attributes)
        
        return attributedString
    }
    
    
    // Sets the project labels
    func setProject(project: Project){
        
        projectTitle.text = project.title

    }
    
    
    // Displays the project status with color
    func setAccessoryStatus(project: Project){
     
        let status = project.status
        
        self.detailTextLabel?.attributedText = setAccessoryStatusColor(status: status, color: UIColor.darkGray)
        
        // Display different UIColors regarding project status
//        switch status {
//        case "active":
//            self.detailTextLabel?.attributedText = setAccessoryStatusColor(status: status, color: UIColor.darkGray)
//        default:
//            self.detailTextLabel?.text = "completed"
//        }
        
    }
    

}
