//
//  AccountViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/23/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    

    @IBOutlet weak var EditAccountButton: UIButton!
    
    @IBOutlet weak var EditContractorsButton: UIButton!
    
    
    @IBOutlet weak var LogOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        EditAccountButton.layer.cornerRadius = 15.0
        EditContractorsButton.layer.cornerRadius = 15.0
        LogOutButton.layer.cornerRadius = 15.0
        
        loadData()
    }
    
    func loadData(){
        let db = Firestore.firestore()
        let userEmail = Auth.auth().currentUser!.email!
        
        db.collection("Customer").whereField("customerEmail", isEqualTo: userEmail)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting data: \(err)")
                } else {
                    for currentDocument in querySnapshot!.documents {
                        let firstname = currentDocument.get("customerFirstName") as! String
                        let lastname = currentDocument.get("customerLastName") as! String
                        let fullname = firstname + " " + lastname
                        self.nameLabel.text = fullname
                        
                        self.emailLabel.text = currentDocument.get("customerEmail") as? String
                        self.phoneNumberLabel.text = currentDocument.get("customerPhoneNumber") as? String
                        self.addressLabel.text = currentDocument.get("customerAddress") as? String
                    }
                }
        }
    }
    
    func transitionToHome(){
         let viewController:UITabBarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController)!

         self.view.window?.rootViewController = viewController
         self.view.window?.makeKeyAndVisible()
     }
}
