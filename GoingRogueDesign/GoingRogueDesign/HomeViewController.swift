//
//  HomeViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/23/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
        
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var ListServicesButton: UIButton!
    
    @IBOutlet weak var FaceBookButton: UIButton!
    
    @IBOutlet weak var TwitterButton: UIButton!
    
    @IBOutlet weak var InstagramButton: UIButton!
    
    @IBOutlet weak var RequestInfoButton: UIButton!
  
    @IBOutlet weak var GRDURLButton: UIButton!
    
    @IBOutlet weak var LinkButton: UIButton!
    
    var tabBarItem1: UITabBarItem?
    var tabBarItem2: UITabBarItem?
    
    override func viewDidLoad() {

        userTabBarValidation()
        
        super.viewDidLoad()
        if let tabBarController = self.tabBarController{
            tabBarController.viewControllers?.remove(at: 1)
        }
        
    
        // Do any additional setup after loading the view.
        ListServicesButton.layer.cornerRadius = 15.0
        RequestInfoButton.layer.cornerRadius = 15.0
        SignInButton.setTitle("Welcome, Sign In", for: .normal)
    }
    
    func tabBarItemsActivate(x: Bool) {
           let tabBarControllerItems = self.tabBarController?.tabBar.items

           if let tabArray = tabBarControllerItems {
                tabBarItem1 = tabArray[2]
                tabBarItem2 = tabArray[3]
           }
           tabBarItem1!.isEnabled = x
           tabBarItem2!.isEnabled = x
       }
    
    // Display the customer's name when he/she has signed in.
    func signInName(){
        let documentEmail = Auth.auth().currentUser!.email
        let customerCollection = Firestore.firestore().collection("Customer")
        
        customerCollection.getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error getting customer: \(err)")
            }
            else{
                for customer in QuerySnapshot!.documents{
                    if (documentEmail == customer.get("customerEmail") as? String){
                        let firstName = customer.get("customerFirstName") as? String ?? "N/A"
                        self.SignInButton.setTitle("Welcome, " + firstName, for: .normal)
                    }
                }
            }
        }
    }
    
    
    func userTabBarValidation(){
        let user = Auth.auth().currentUser
        
        if (user != nil){
            tabBarItemsActivate(x: true)
            signInName()
        }
        else{
            tabBarItemsActivate(x: false)
        }
        
    }
    
    // Open the correct url when a certain button get tapped.
    @IBAction func FaceBookButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.facebook.com/goingroguedesign/?ref=aymt_homepage_panel")! as URL, options: [:], completionHandler: nil)

    }
    
    
    @IBAction func TwitterButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://twitter.com/design_going/")! as URL, options: [:], completionHandler: nil)
        
    }
    
    
    @IBAction func InstagramButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.instagram.com/goingroguedesign/")! as URL, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func GRDButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.goingroguedesignllc.com")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func LinkButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.goingroguedesignllc.com")! as URL, options: [:], completionHandler: nil)
    }
    
    
    // Check if there is a current user and make the button have different reactions
    @IBAction func SignInButtonTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
               
        if (user != nil){
            self.tabBarController!.selectedIndex = 2
        }
        else{
           performSegue(withIdentifier: "showSignInScreen", sender: nil)
        }
    }
}
