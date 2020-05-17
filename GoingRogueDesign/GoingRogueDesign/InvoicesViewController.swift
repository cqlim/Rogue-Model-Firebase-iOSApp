//
//  InvoicesViewController.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 3/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit
import Firebase

class InvoicesViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var project: Project!
    var invoices: [Invoice] = []
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.refreshControl = myRefreshControl
        
        // table height with the PaidDate label included
        tableview.rowHeight = 61
        
        navigationItem.title = project.title
        createArray()
        
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // Pull down to refresh the data
    @objc func refresh(sender: UIRefreshControl){
        self.invoices.removeAll()
        createArray()

        tableview.refreshControl?.endRefreshing()
    }
    
    // Creates the Invoice array
    func createArray(){
        let db = Firestore.firestore()
        let projectID = project.id
        
        print("ProjectID： \(projectID)")
        
        // Fetch the invoice data based on current project ID
        db.collection("Invoice").whereField("projectID", isEqualTo: projectID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting invoices: \(err)")
                } else {
                    for currentInvoice in querySnapshot!.documents {
                        print("Project name： \(currentInvoice.get("invoiceName"))")
                        let uploadDateTimeStamp = currentInvoice.get("invoiceDueDate") as! Timestamp
                        let uploadDateString = dateToStringConverter(date: uploadDateTimeStamp.dateValue(), time:false)
                        
                        let invoicePaidDate = currentInvoice.get("invoicePaidDate") as? Timestamp ?? nil
                        var stringPaidDate: String
                        
                        if(invoicePaidDate == nil){
                            stringPaidDate = "N/A"
                        }
                        else{
                            stringPaidDate = dateToStringConverter(date: invoicePaidDate!.dateValue(), time: true)
                        }
                        
                        let invoice = Invoice(dueDate: uploadDateString, url: currentInvoice.get("invoiceLink") as? String ?? "N/A", name: currentInvoice.get("invoiceName") as? String ?? "N/A", paid: (currentInvoice.get("invoiceType") as? String)!, projectID: currentInvoice.get("projectID") as? String ?? "N/A", invoiceID: currentInvoice.get("invoiceID") as? String ?? "N/A", dueDateForChecking: uploadDateTimeStamp.dateValue(), paidDate: stringPaidDate)
                        
                        
                        self.invoices.append(invoice)
                    }
                        
                    self.tableview.reloadData()
                }
        }
    }

    // Change the state of the checkbox when it's clicked
    @IBAction func paidButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let cell = sender.superview?.superview as? InvoicesCell else{
            print("Error in retrieving the indexPath from paidButtonTapped()")
            return
        }
         
        let indexPath = tableview.indexPath(for: cell)
        let invoice = invoices[indexPath!.row]
        let db = Firestore.firestore()
        let currentTime = Date()
        
        if(sender.isSelected){
        db.collection("Invoice").document(invoice.invoiceID).setData(["invoiceType":"paid","invoicePaidDate":currentTime], merge: true)
            
            // updates a single cell
            invoice.paid = "paid"
            invoice.paidDate = dateToStringConverter(date: currentTime, time: true)
            updateSingleCell(invoice: invoice, indexPath: indexPath!)
        }
        else{

        db.collection("Invoice").document(invoice.invoiceID).setData(["invoiceType":"unpaid","invoicePaidDate":""], merge: true)
            
            // updates a single cell
            invoice.paid = "unpaid"
            invoice.paidDate = ""
            updateSingleCell(invoice: invoice, indexPath: indexPath!)

        }
    }
    
    // This function updates a single cell when a user clicks a check box
    func updateSingleCell(invoice: Invoice, indexPath: IndexPath){
        let newCell = tableview.cellForRow(at: indexPath) as? InvoicesCell
        newCell?.paidButtonStatus(invoice: invoice)
        let dueDate = newCell?.checkOverdue(invoice: invoice)
        newCell?.setInvoice(invoice: invoice,dueDate: dueDate!)
    }
    
}

extension InvoicesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currInvoice = invoices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as! InvoicesCell
        
        cell.paidButtonStatus(invoice: currInvoice)
        let dueDate = cell.checkOverdue(invoice: currInvoice)
        cell.setInvoice(invoice: currInvoice,dueDate: dueDate)
        
        return cell
    }
    
    
    // This function is for only to increase the height for a certain row
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height: CGFloat = CGFloat()
//        let currInvoice = invoices[indexPath.row]
//        if(currInvoice.paid == "paid"){
//            // Height after adding the invoicePaidDate label
//            height = 61
//
//        }
//        else{
//            // Same height as the task table's height
//            height = 44
//        }
//
//        return height
//    }
//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currInvoice = invoices[indexPath.row]
        let url = currInvoice.url
        
        UIApplication.shared.open(URL(string:url)! as URL, options: [:], completionHandler: nil)

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
        
}
