//
//  EditAccountViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 2/11/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class EditAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Disable keyboard show up while user press other places
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        // Do any additional setup after loading the view.
        updateButton.layer.cornerRadius = 15.0
        errorLabel.alpha = 0
        
        loadData()
    }
    

    func loadData(){
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser!.email!
        
        db.collection("Customer").whereField("customerEmail", isEqualTo: userEmail)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    self.showError("Couldn't load data.")
                } else {
                    for currentDocument in querySnapshot!.documents {
                        self.userID = currentDocument.get("customerID") as! String
                        
                        self.firstNameTextField.text = currentDocument.get("customerFirstName") as? String
                        self.lastNameTextField.text = currentDocument.get("customerLastName") as? String
                        self.phoneNumberTextField.text = currentDocument.get("customerPhoneNumber") as? String
                        self.addressTextField.text = currentDocument.get("customerAddress") as? String
                    }
                }
        }
    }
    
    
    
    @IBAction func updateTapped(_ sender: Any) {
        //Get the user's inputs
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Get the reference of the current user's document id
        let db = Firestore.firestore()
        //let userEmail = Auth.auth().currentUser!.email
        
        //Update the data
        if userID != ""{
            db.collection("Customer").document(self.userID).setData(["customerFirstName":firstName, "customerLastName":lastName,"customerAddress":address, "customerPhoneNumber":phoneNumber], merge: true) { (error) in
                if error != nil{
                    self.showError("Failing to update the information")
                }
                else{
                    self.errorLabel.textColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
                    self.errorLabel.text = "All the changes have been saved."
                    self.errorLabel.alpha = 1
                }
            }
            
        }
            else{
                self.errorLabel.textColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
                self.errorLabel.text = "All the changes have been saved."
                self.errorLabel.alpha = 1
            }
        }
        
    
    
    
    func showError(_ message:String){
        self.errorLabel.textColor = UIColor.red
        self.errorLabel.text = message
        self.errorLabel.alpha = 1
    }
    
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

}
