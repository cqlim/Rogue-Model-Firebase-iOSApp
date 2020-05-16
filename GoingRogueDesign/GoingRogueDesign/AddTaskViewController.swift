//
//  AddTaskViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 5/12/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol addTaskDelegate{
    func reloadTaskList()
}

class AddTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: UITextField!
    
    
    @IBOutlet weak var dueDateTextField: UITextField!
    
    
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    
    @IBOutlet weak var descriptionCharCountLabel: UILabel!
    
    @IBOutlet weak var createTaskButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var delegate: addTaskDelegate?
    
    var customerEmail = ""
    var projectID = ""
    var userID = ""
    private var datePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneac))
        toolBar.setItems([doneButton], animated: true)
        dueDateTextField.inputAccessoryView = toolBar
        dueDateTextField.inputView = datePicker
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Disable keyboard show up while user press other places
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
                
        self.createTaskButton.layer.cornerRadius = 15.0
        taskDescriptionTextView.layer.borderWidth = 1
        taskDescriptionTextView.layer.cornerRadius = 5
        taskDescriptionTextView.layer.borderColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1).cgColor
        self.errorLabel.alpha = 0

        
        taskDescriptionTextView.delegate = self
        self.updateCharacterCount()
        
        print(customerEmail)
        print(projectID)
        print(userID)

    }
    
    // Show how many characters are able to be texted.
    func updateCharacterCount() {
        let descriptionCount = self.taskDescriptionTextView.text.count

        self.descriptionCharCountLabel.text = "\((0) + descriptionCount)/200"
    }

    // Update the textview's current characters' count
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }

    // Check if the characters exceed the limitation. If it is, disable editing.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == taskDescriptionTextView){
           return textView.text.count +  (text.count - range.length) <= 200
        }
        return false
    }
    

    @IBAction func createTaskButtonTapped(_ sender: Any) {
        print("I want to create a new task")
        //Get the user's inputs
        let newTaskName = taskNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //let newTaskDueDate = dueDateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newTaskDescription = taskDescriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        if newTaskName == "" || dueDateTextField.text == "" || newTaskDescription == ""{
            self.showError("Please fill in all the fields to create a new task.")
        }
        else{
            //Get the reference of the current user's document id
            let db = Firestore.firestore()
            let newTask = db.collection("Task").document()
            let currentTime = Date()
            
            print("CurrentTime is: \(currentTime)")
            //Update the data
            newTask.setData(["customerEmail":customerEmail, "projectID":projectID,"taskCreatedDate":currentTime, "taskDescription":newTaskDescription, "taskDueDate": datePicker.date, "taskID":newTask.documentID, "taskName":newTaskName, "taskResolvedDate": "", "taskType": "ongoing", "userID":userID], merge: true) { (error) in
                if error != nil{
                    self.showError("Failing to create new task")
                }
                else{
                    self.errorLabel.textColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
                    self.errorLabel.text = "The new task has been created successfully. Linking you back to the task list now ......"
                    self.errorLabel.lineBreakMode = .byWordWrapping
                    self.errorLabel.numberOfLines = 0
                    self.errorLabel.alpha = 1
                    
                    // Use the delegate to let previous view controller reload its data
                    if let delegate = self.delegate {
                        delegate.reloadTaskList()
                    }
                    
                    // Give user a wait time to load the data
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func showError(_ message:String){
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.text = message
        self.errorLabel.alpha = 1
    }
    
    // Allow user to dismiss the keyboard.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height*0.3
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Set up the date picker's display data into a proper format.
    @objc func doneac(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE   MM/dd/yyyy"
        print("datePicker.date is: \(datePicker.date)")

        
        dueDateTextField.text = dateFormatter.string(from: datePicker.date)
        dueDateTextField.textColor = UIColor.black
        view.endEditing(true)
    }
}
