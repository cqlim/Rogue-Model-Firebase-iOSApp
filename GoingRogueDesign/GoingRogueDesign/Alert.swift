//
//  Alert.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 5/6/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you wang to log out?", preferredStyle: .alert)
    }
}
