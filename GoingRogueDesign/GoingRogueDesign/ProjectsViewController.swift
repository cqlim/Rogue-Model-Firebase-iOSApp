//
//  ProjectsViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/23/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class ProjectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var projects: [Project] = []
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = myRefreshControl

        createProjectArray()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    // Pull down to refresh the data
    @objc func refresh(sender: UIRefreshControl){
        self.projects.removeAll()
        createProjectArray()

        tableView.refreshControl?.endRefreshing()
    }

    // Go through the list of projects from the DB and retrieve projects based on "customerEmail"
    func createProjectArray(){
        let documentEmail = Auth.auth().currentUser!.email
        let db = Firestore.firestore().collection("Project")
        
        db.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in QuerySnapshot!.documents{
                    if (documentEmail == document.get("customerEmail") as? String){
                        
                        let timeStamp = document.get("projectStartDate") as! Timestamp
                        let dateString = dateToStringConverter(date: timeStamp.dateValue(), time: true)
                       
                        let _Project = Project(title: document.get("projectName") as? String ?? "N/A", address: document.get("projectAddress") as? String ?? "N/A", status: document.get("projectType") as? String ?? "N/A", startDate: dateString, description: document.get("projectDescription") as? String ?? "N/A", id: document.get("projectID") as? String ?? "N/A", longitude: document.get("projectLongitude") as? Float64 ?? 0.0, latitude: document.get("projectLatitude") as? Float64 ?? 0.0, manager: document.get("managerName") as? String ?? "N/A", mainContractor: document.get("projectMainContractorName") as? String ?? "N/A")
                        
                        self.projects.append(_Project)
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
    }

}

// For UITable view extension
extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate{
        
    // Determine how many rows should table view actually show
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    // Configuring each and every project cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectsViewCell
        
        cell.setProject(project: project)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowProjectDetail", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Pass data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowProjectDetail"{
            if let vc = segue.destination as? ProjectDetailViewController{
                let row = self.tableView.indexPathForSelectedRow!.row
                vc.project = projects[row]
            }
        }
        
    }
}
