//
//  ReqInfoSubmitViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/30/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import MessageUI


class ReqInfoSubmitViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var messageTextView: UITextView!
   
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Disable keyboard show up while user press other places
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        // Set up message textview's properties
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 5
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor

        // Set up submit button's properties
        submitButton.layer.cornerRadius = 15.0
    }
    
    func validateFields() -> String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            messageTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let viewController:UITabBarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController)!

        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }

    
    @IBAction func sendEmail(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
            return
        }
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = messageTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        guard MFMailComposeViewController.canSendMail() else{
            showError("Mail services are not available.")
            return
        }
        
        // Fill the mail composer by user's input
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["1787829765@qq.com"])
        composer.setSubject("Request Information")
        composer.setMessageBody("First Name:  \(firstName)\n\nLast Name:  \(lastName)\n\nEmail:  \(email)\n\nMessage:  \(message)\n\n", isHTML: false)
        
        self.present(composer, animated: true)
        
        cleanTextFields()
    }



    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
        if let _ = error{
            controller.dismiss(animated: true)
            return
        }
        
        switch result{
        case MFMailComposeResult.cancelled:
            self.dismiss(animated: true)
        case MFMailComposeResult.failed:
            self.dismiss(animated: true)
        case MFMailComposeResult.saved:
            self.dismiss(animated: true)
        case MFMailComposeResult.sent:
            self.dismiss(animated: true)
        default:
            break
        }
    }
    
   
    func cleanTextFields() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        messageTextView.text = ""
        errorLabel.text = "";
        errorLabel.alpha = 0;
    }

    // Allow user to dismiss the keyboard
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
