//
//  LogOutViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 4/27/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogOutViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var denyButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true

    }
    

    @IBAction func confirmTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        transitionToHome()
    }
    

    @IBAction func denyTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func transitionToHome(){
         let viewController:UITabBarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController)!

         self.view.window?.rootViewController = viewController
         self.view.window?.makeKeyAndVisible()
     }
}
