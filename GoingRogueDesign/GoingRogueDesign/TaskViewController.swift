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
    var taskDueDateAttributedString = NSAttributedString()

    // Pull down to refresh feature
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.refreshControl = myRefreshControl
        
        navigationItem.title = project.title
        createTaskArray()
    }
  
    // Pull down to refresh the data
    @objc func refresh(sender: UIRefreshControl){
        self.tasks.removeAll()
        createTaskArray()

        taskTableView.refreshControl?.endRefreshing()
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
                            let stringTaskDueDate = dateToStringConverter(date: taskDueDate.dateValue(), time: true)
                            
                            let taskResolvedDate = document.get("taskResolvedDate") as? Timestamp ?? nil
                            var stringResolvedDate: String
                            
                            if(taskResolvedDate == nil){
                                stringResolvedDate = "N/A"
                            }
                            else{
                                stringResolvedDate = dateToStringConverter(date: taskResolvedDate!.dateValue(), time: true)
                            }
                            
                            
                            let _Task = Task(name: document.get("taskName") as? String ?? "N/A", status: document.get("taskType") as? String ?? "N/A",  dueDate: stringTaskDueDate, description: document.get("taskDescription") as? String ?? "N/A", resolvedDate: stringResolvedDate, id: document.get("taskID") as? String ?? "N/A", overdue: taskDueDate.dateValue())
                            
                            self.tasks.append(_Task)
                        }
                    }
                    self.taskTableView.reloadData()
                }
            }
        }
    

    // Change the state of the checkbox when it's clicked
    @IBAction func resolvedButtonTapped(_ sender: UIButton) {
//        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear,
//                       animations: {
//                        sender.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
//        }){ (success) in
//            sender.isSelected = !sender.isSelected
//            UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
//                sender.transform = .identity
//            }, completion: nil)
//        }
        
        sender.isSelected = !sender.isSelected
        
        guard let cell = sender.superview?.superview as? TaskViewCell else{
            print("Error in retrieving the indexPath from resolvedButtonTapped()")
            return
        }
         
        let indexPath = taskTableView.indexPath(for: cell)
        let task = tasks[indexPath!.row]
        let db = Firestore.firestore()
        let currentTime = Date()
        
        // Sends the state of the task to the Firebase database
        if(sender.isSelected){
            db.collection("Task").document(task.taskID).setData(["taskType":"completed", "taskResolvedDate":currentTime], merge: true)
            
            
            // This updates a single cell upon clicking
            task.taskStatus = "completed"
            task.taskResolvedDate = dateToStringConverter(date: currentTime, time: true)
            updateSingleCell(task: task, indexPath: indexPath!)
        }
        else{
        db.collection("Task").document(task.taskID).setData(["taskType":"ongoing","taskResolvedDate":""], merge: true)
            
            
            // This updates a single cell upon clicking
            task.taskStatus = "ongoing"
            task.taskResolvedDate = "N/A"
            updateSingleCell(task: task, indexPath: indexPath!)
            
        }

    }
    
    
    // This function updates a single cell when a user clicks a check box
    func updateSingleCell(task: Task, indexPath: IndexPath){
        let newCell = taskTableView.cellForRow(at: indexPath) as? TaskViewCell
        newCell?.resolvedButtonStatus(task: task)
        let dueDate = newCell?.checkOverdue(task: task)
        newCell?.setTask(task: task,dueDate: dueDate!)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return tasks.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskViewCell
        
        cell.resolvedButtonStatus(task: task)
        
        // Retrieving the red or black due date string
        taskDueDateAttributedString = cell.checkOverdue(task: task)
        cell.setTask(task: task, dueDate: taskDueDateAttributedString)
        
        return cell
       }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let db = Firestore.firestore()
            let task = tasks[indexPath.row]
            // handle delete (by removing the data from your array and updating the tableview)
            taskTableView.beginUpdates()
            tasks.remove(at: indexPath.row)
            taskTableView.deleteRows(at: [indexPath], with: .fade)
            db.collection("Task").document(task.taskID).delete()
            taskTableView.endUpdates()
        }
    }
  
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "createTask", sender: self)
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
            
            if segue.identifier == "createTask"{
                if let addTaskvc = segue.destination as? AddTaskViewController{
                    addTaskvc.customerEmail = Auth.auth().currentUser!.email!
                    addTaskvc.userID = Auth.auth().currentUser!.uid
                    addTaskvc.projectID =  self.project.id
                    addTaskvc.delegate = self
                }
            }
    }
    

    }


extension TaskViewController: addTaskDelegate{
    func reloadTaskList() {
        self.tasks.removeAll()
        createTaskArray()
    }
    
}
    
    
   


