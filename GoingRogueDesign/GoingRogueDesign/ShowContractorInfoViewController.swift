//
//  ShowContractorInfoViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 2/15/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

// Create a protocol to use the delegates
protocol contractorInfoDelegate{
    func reload()
}

class ShowContractorInfoViewController: UIViewController, UITextFieldDelegate {

    //var myContractor = contractor(firstName: "", lastName: "", phoneNumber: "", email: "")

    @IBOutlet weak var contractorNameLabel: UILabel!
    
    @IBOutlet weak var contractorFirstNameTextField: UITextField!

    @IBOutlet weak var contractorLastNameTextField: UITextField!
    
    @IBOutlet weak var contractorPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var contractorEmailTextField: UITextField!
    
    @IBOutlet weak var addContractorButton: UIButton!
    

    @IBOutlet weak var errorLabel: UILabel!
    
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    var userEmail = ""
    
    // Create the delegate variable
    var delegate: contractorInfoDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contractorFirstNameTextField.text = firstName
        contractorLastNameTextField.text = lastName
        contractorPhoneNumberTextField.text = phoneNumber
        contractorEmailTextField.text = email
        errorLabel.alpha = 0
        
        // Disable keyboard show up while user press other places
       let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
       view.addGestureRecognizer(Tap)
       
       // Do any additional setup after loading the view.
       addContractorButton.layer.cornerRadius = 10.0
        
        // Check the contractor input, display different page layout depends on if the name is empty.
        if contractorFirstNameTextField.text != ""{
            buildContractorInfoPage()
        }
        else{
            buildAddContractorPage()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    func buildAddContractorPage(){
        contractorFirstNameTextField.isUserInteractionEnabled = true
        contractorLastNameTextField.isUserInteractionEnabled = true
        contractorPhoneNumberTextField.isUserInteractionEnabled = true
        contractorEmailTextField.isUserInteractionEnabled = true
        addContractorButton.isEnabled = true
        addContractorButton.alpha = 1
        
    }
    
    func buildContractorInfoPage(){
        contractorFirstNameTextField.isUserInteractionEnabled = false
        contractorLastNameTextField.isUserInteractionEnabled = false
        contractorPhoneNumberTextField.isUserInteractionEnabled = false
        contractorEmailTextField.isUserInteractionEnabled = false
        addContractorButton.isEnabled = false
        addContractorButton.alpha = 0
    }

    @IBAction func addContractorTapped(_ sender: Any) {
        //Get the user's inputs
        let newFirstName = contractorFirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newLastName = contractorLastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newEmail = contractorEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPhoneNumber = contractorPhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newFirstName == "" || newLastName == "" || newPhoneNumber == "" || newEmail == ""{
            self.showError("Please fill in all the fields to add new contractor.")
        }
        else{
            //Get the reference of the current user's document id
            let db = Firestore.firestore()
            let newContractor = db.collection("Contractor").document()
            
            
            //Update the data
            newContractor.setData(["contractorFirstName":newFirstName, "contractorLastName":newLastName,"contractorEmail":newEmail, "contractorPhoneNumber":newPhoneNumber, "customerEmail": userEmail], merge: true) { (error) in
                if error != nil{
                    self.showError("Failing to create new contractor")
                }
                else{
                    self.errorLabel.textColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
                    self.errorLabel.text = "The new contractor has been added successfully."
                    self.errorLabel.lineBreakMode = .byWordWrapping
                    self.errorLabel.numberOfLines = 0
                    self.errorLabel.alpha = 1
                    
                    // Use the delegate to let previous view controller reload its data
                    if let delegate = self.delegate {
                        delegate.reload()
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    func showError(_ message:String){
        errorLabel.textColor = UIColor.red
        errorLabel.text = message
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
        errorLabel.alpha = 1
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
