//
//  EditContractorsViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 2/12/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

struct contractor{
    var firstName    : String
    var lastName     : String
    var phoneNumber  : String
    var email        : String
}

class EditContractorsViewController: UIViewController {
    var scrollView = UIScrollView()
    var contentView = UIView()
    var stackView = UIStackView()
    var titleLabel = UILabel()
    var errorLabel = UILabel()
    let infoVC = ShowContractorInfoViewController()
    var index = 0
    var position = 0
    var contractorNumber = 0
    var contractorArray = [contractor]()
    var currentContractor = contractor(firstName:"", lastName:"", phoneNumber:"", email:"")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the scrollview into the current view.
        self.view.addSubview(self.scrollView)
        setUpScrollView()
        
        // Add the title label into the content view.
        self.contentView.addSubview(titleLabel)
        setUpTitle()
        
        // Go to the firestore and check if the current user has any contractor
        checkContractors()

    }
    
    func setUpScrollView(){
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.scrollView.addSubview(self.contentView)
        
        // Set up content view's constraints
        self.scrollView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true;
        self.scrollView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true;
//        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true;
//        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true;

        
        // Set up content view's constraints
        self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
//        self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true;
//        self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true;
    }
    
    func checkContractors(){
        let db = Firestore.firestore()
        //let userID = Auth.auth().currentUser?.uid
        let userEmail = Auth.auth().currentUser?.email
        
        //print("User Email is: \(userEmail)")
        
        // Loop through the collection contractor's documents
        db.collection("Contractor").whereField("customerEmail", isEqualTo: userEmail!).getDocuments(){ (snapshot, error) in
            // If can not fetch data
            if error != nil{
                let errorMessage = "Sorry, some error occurs while getting the data."
                self.showError(errorMessage)
            }else{
                // Loop the doocuments and heck if the current document's customer ID equal userID
                for document in snapshot!.documents{
                    
//                    print(document.documentID)
                    let constractorFirstName = document.get("contractorFirstName") as! String
                    let constractorLastName = document.get("contractorLastName") as! String
                    let constractorEmail = document.get("contractorEmail") as! String
                    let constractorPhoneNumber = document.get("contractorPhoneNumber") as! String
                    
                    // Create the new constractor object and add it into arrayList
                    let currentConstractor = contractor(firstName: constractorFirstName, lastName: constractorLastName, phoneNumber: constractorPhoneNumber, email: constractorEmail)
                    
                    // Add the valid contractor into the contractorArray
                    self.contractorArray.append(currentConstractor)
                    
                    // Increment the counter
                    self.contractorNumber += 1
                }
            }
            
            // Build page depends on the amount of valid contractor
            self.buildPage()
        }
    }



    func buildPage(){
        // If the current user doesn't has contractors:
        if(contractorNumber == 0){
            // Add the error label into the content view.
            contentView.addSubview(errorLabel)
            let errorMessage = "Sorry, looks like you don't have any contractor yet."
            showError(errorMessage)
        }else{
            
        // If the current user has contractors:
            // 1. Build and configure the vertical stack view
            // 2. Show the vertical stack view
            setUpStackView()
            
            // 3. Build and configure the buttons and put them into the stack view that I just created
                // Set these button's title by the contractor's first name + last name
            addContractorButtonsToStackView()
        
            // 4. Add a "+" button under the last contractor's button outside of the stack view
            addInsertionButtonsToStackView()
        
        }
    }
    
    
    
    
    func setUpStackView(){
        //Add and setup stack view
        self.contentView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.distribution = .equalSpacing
        self.stackView.spacing = 20;

        // Set up stack view's constraints to content view
        self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true;
        self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 90).isActive = true;
        self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true;
        self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -40).isActive = true;
        
    }
    
    
    
    func setUpTitle(){
        self.titleLabel.text = "Contractors Information"
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont(name: "Arial-BoldMT", size: CGFloat(20))
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 35).isActive = true;
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true;
        self.titleLabel.alpha = 1;
    }
    
    
    
    func showError(_ message:String){
        self.errorLabel.text = message
        //errorLabel.textColor = UIColor.red
        self.errorLabel.textColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
        self.errorLabel.font = UIFont(name: "Arial", size: CGFloat(19))
        self.errorLabel.textAlignment = .center
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.numberOfLines = 0
        
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.errorLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.errorLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 3/4).isActive = true
                
        self.errorLabel.alpha = 1;
    }
    
    
    
    func addContractorButtonsToStackView(){
        for contractor in contractorArray{
            let button = UIButton()
            button.setTitle("\(contractor.firstName) \(contractor.lastName)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .red
            
//            button.backgroundColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
            button.layer.borderWidth = 2.5
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 10
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
            button.titleLabel?.font = UIFont(name: "Arial", size: CGFloat(20))
            button.tag = index
            button.addTarget(self, action: #selector(contractorButtonAction), for: .touchUpInside)
            // 4. Add the feature that when any of these contractor's button get clicked
                    // (1) Save the data of the current contractor
            
                    // (2) Pass this contractor's data to a new view controller which displays the contractor's information
            self.stackView.addArrangedSubview(button)
            index = index + 1
        }
    }
    
    
    
    @objc func contractorButtonAction(sender: UIButton){
        position = sender.tag
        performSegue(withIdentifier: "contractorInfo", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.currentContractor = contractorArray[position]
        let vc = segue.destination as! ShowContractorInfoViewController
        vc.phoneNumber = self.currentContractor.phoneNumber
        vc.firstName = self.currentContractor.firstName
        vc.lastName =  self.currentContractor.lastName
        vc.email = self.currentContractor.email
        vc.userEmail = Auth.auth().currentUser!.email!
        
        // Make sure the next VC's delegate is the current VC
        vc.delegate = self
    }
    
    
    
    func addInsertionButtonsToStackView(){
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        
//            button.backgroundColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.titleLabel?.font = UIFont(name: "Arial", size: CGFloat(35))
        
        // 5. Add the feature that when the "+" button get clicked:
        button.addTarget(self, action: #selector(insertionButtonAction), for: .touchUpInside)
                
        self.stackView.addArrangedSubview(button)
    }
    

    
    @objc func insertionButtonAction(){
        // Create a new button and set title to "New Contractor"
        let button = UIButton()
        button.setTitle("New Contractor", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        
    //            button.backgroundColor = UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.titleLabel?.font = UIFont(name: "Arial", size: CGFloat(20))
        button.tag = index
        contractorArray.append(contractor(firstName: "", lastName: "", phoneNumber: "", email: ""))
        button.addTarget(self, action: #selector(contractorButtonAction), for: .touchUpInside)
        
        // Put the new button into the stack view under the current last contractor
        self.stackView.insertArrangedSubview(button, at: index)
        index = index + 1
    }
    
}

// Use the protocal in the class, so that when showContratorInforVC call the function it will reload the page.
extension EditContractorsViewController: contractorInfoDelegate{
    func reload() {
        
        // Delete the current subviews in the view.
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        // Reintialize the global variables.
        scrollView = UIScrollView()
        contentView = UIView()
        stackView = UIStackView()
        titleLabel = UILabel()
        errorLabel = UILabel()
        index = 0
        position = 0
        contractorNumber = 0
        contractorArray = [contractor]()
        currentContractor = contractor(firstName:"", lastName:"", phoneNumber:"", email:"")
        
        // Recall viewDidLoad() to reload the screen.
        viewDidLoad()
    }
        // Go to the firestore and check if the current user has any contractor
        
        
        
        // If the current user has contractors:

            // 1. Create an array and store the current user's contractors
        
        
            // 2. Build and configure the vertical stack view
        
        
            // 3. Show the vertical stack view
        
            
            // 4. Build and configure the buttons and put them into the stack view that I just created
                // Set these button's title by the contractor's first name + last name
            
        
            // 5. Add the feature that when any of these contractor's button get clicked
                // (1) Save the data of the current contractor
        
                // (2) Pass this contractor's data to a new view controller which displays the contractor's information
        
        
            // 6. Add a "+" button under the last contractor's button outside of the stack view
        
            
            // 7. Add the feature that when the "+" button get clicked:
                // (1) Create a new button and set title to "New Contractor"
        
                // (2) Create a new constractor's document in the firestore and set data to empty
        
                // (3) Put the new button into the stack view under the current last contractor
        
        
        // If the current user doesn't has contractors:
        
            // 1. Build, configure the label
                //Set the label's color to "UIColor(red:0.28, green:0.60, blue:0.94, alpha: 1)"
        
                //Set the label's text to "Sorry, looks like you don't have any contractors yet."
        
           
            // 2. Show the Label
        

}
