//
//  LoSPopupViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class LoSPopupViewController: UIViewController {

//    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var viewCloseButton: UIButton!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        okButton.layer.cornerRadius = 15.0
    }
    

//    @IBAction func closeButtonTapped(_ sender: Any) {
//        self.transitionToHome()
//    }
    
    @IBAction func viewCloseButtonTapped(_ sender: Any) {
        self.transitionToHome()
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.transitionToHome()
    }
    
    func transitionToHome(){
        let viewController:UITabBarController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? UITabBarController)!

        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
}
