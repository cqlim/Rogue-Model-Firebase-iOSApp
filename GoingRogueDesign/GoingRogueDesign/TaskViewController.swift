//
//  TaskViewController.swift
//  GoingRogueDesign
//
//  Created by Cheng Lim on 4/2/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var taskTableView: UITableView!
    var tasks: [Task] = []
    var project: Project!
    var selectedtasks : Task!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = project.title
        createTaskArray()
    }
  
    // retrieve data from the firebase and store as a task array
     func createTaskArray(){
            let db = Firestore.firestore().collection("Task")
            let projectID = project.id
        
            db.getDocuments(){(QuerySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    for document in QuerySnapshot!.documents{
                        if (projectID == document.get("projectID") as? String){
                            
                            let taskDueDate = document.get("taskDueDate") as! Timestamp
                            
                            let stringTaskDueDate = dateToStringConverter(date: taskDueDate.dateValue(), time: false)
                            
                            let taskResolvedDate = document.get("taskResolvedDate") as? Timestamp ?? nil
                            var stringResolvedDate: String
                            
                            if(taskResolvedDate == nil){
                                stringResolvedDate = "N/A"
                            }
                            else{
                                stringResolvedDate = dateToStringConverter(date: taskResolvedDate!.dateValue(), time: false)
                            }
                            
                            
                            let _Task = Task(name: document.get("taskName") as? String ?? "N/A", status: document.get("taskType") as? String ?? "N/A",  dueDate: stringTaskDueDate, description: document.get("taskDescription") as? String ?? "N/A", resolvedDate: stringResolvedDate)
                            
                            self.tasks.append(_Task)
                        }
                    }
                    self.taskTableView.reloadData()
                }
            }
        }
    

    
    @IBAction func resolvedButtonTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }){ (success) in
            sender.isSelected = !sender.isSelected
            UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
                

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return tasks.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskViewCell
        
        cell.resolvedButtonStatus(status: task.taskStatus)
        
        cell.setTask(task: task)
        
        return cell
       }
  
    // Might need to redo the segue because this currently doesn't work
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ShowMoreTask", sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
    
    // Pass data through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "ShowMoreTask"{
                if let vc = segue.destination as? MoreTaskViewController{
                    let row = self.taskTableView.indexPathForSelectedRow!.row
                    vc.tasks = tasks[row]
                }
            }
    }
    

    }
    
    
   


