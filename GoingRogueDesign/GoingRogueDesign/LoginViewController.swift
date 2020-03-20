//
//  LoginViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTExtField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        loginButton.layer.cornerRadius = 15.0
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
         let email = userNameTExtField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

         Auth.auth().signIn(withEmail: email, password: password) { (result, error) in

             if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                self.loginButton.alpha = 1
             }
             else {

                self.transitionToHome()
                
            }
        }
    }
    
    func transitionToHome(){
        let viewController:UITabBarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController)!

        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()        
    }
    
}
