//
//  ProjectDetailViewController.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/6/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {

    
    //Labels
    @IBOutlet weak var ProjectTitle: UILabel!
    @IBOutlet weak var ProjectAddress: UILabel!
    @IBOutlet weak var ProjectDescription: UILabel!
    @IBOutlet weak var ProjectStatus: UILabel!
    @IBOutlet weak var ProjectStartDate: UILabel!
    
    // Buttons    
    @IBOutlet weak var DocumentButton: UIButton!
        
    @IBOutlet weak var TaskButton: UIButton!
    
    @IBOutlet weak var InvoiceButton: UIButton!
    @IBOutlet weak var CalendarButton: UIButton!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProjectTitle.text = project.title
        ProjectAddress.text = project.address
        ProjectStatus.text = "Status: " + project.status
        ProjectDescription.text = "Description: " + project.description
        ProjectStartDate.text = "Start Date: " + project.startDate

        DocumentButton.layer.cornerRadius = 10
        InvoiceButton.layer.cornerRadius = 10
        TaskButton.layer.cornerRadius = 10
        CalendarButton.layer.cornerRadius = 10
    }
    
    @IBAction func InvoiceButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goInvoicesList", sender: self)
    }
    // Pass data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowProjectDocuments"{
            if let vc = segue.destination as? ProjectDocumentsViewController{
                vc.project = project
            }
        }
        if segue.identifier == "ShowTask"{
            if let vc = segue.destination as? TaskViewController{
                vc.project = project
            }
        }

		if segue.identifier == "goInvoicesList"{
			if let vc = segue.destination as? InvoicesViewController{
					vc.project = project
				}
			}

    }
    

}
