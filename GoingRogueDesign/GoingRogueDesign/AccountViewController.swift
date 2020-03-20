//
//  AccountViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 1/23/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var EditAccountButton: UIButton!
    
    @IBOutlet weak var EditContractorsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        EditAccountButton.layer.cornerRadius = 15.0
        EditContractorsButton.layer.cornerRadius = 15.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
