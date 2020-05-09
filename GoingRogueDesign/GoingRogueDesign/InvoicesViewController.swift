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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = project.title
        createArray()
        
        tableview.dataSource = self
        tableview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func createArray(){
        let db = Firestore.firestore()
        let projectID = project.id
        
        print("ProjectID： \(projectID)")
        
        db.collection("Invoice").whereField("projectID", isEqualTo: projectID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print("Error getting invoices: \(err)")
                } else {
                    for currentInvoice in querySnapshot!.documents {
                        print("Project name： \(currentInvoice.get("invoiceName"))")
                        let uploadDateTimeStamp = currentInvoice.get("invoiceDueDate") as! Timestamp
                        let uploadDateString = dateToStringConverter(date: uploadDateTimeStamp.dateValue(), time:false)
                        
                        
                        
                        let invoice = Invoice(dueDate: uploadDateString, url: currentInvoice.get("invoiceLink") as? String ?? "N/A", name: currentInvoice.get("invoiceName") as? String ?? "N/A", paid: (currentInvoice.get("invoiceType") as? String)!, projectID: currentInvoice.get("projectID") as? String ?? "N/A", invoiceID: currentInvoice.get("invoiceID") as? String ?? "N/A", dueDateForChecking: uploadDateTimeStamp.dateValue())
                        
                        
                        self.invoices.append(invoice)
                    }
                        
                    self.tableview.reloadData()
                }
        }
    }

    @IBAction func paidButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let cell = sender.superview?.superview as? InvoicesCell else{
            print("Error in retrieving the indexPath from paidButtonTapped()")
            return
        }
         
        let indexPath = tableview.indexPath(for: cell)
        let invoice = invoices[indexPath!.row]
        let db = Firestore.firestore()
        
        if(sender.isSelected){
            db.collection("Invoice").document(invoice.invoiceID).setData(["invoiceType":"paid"], merge: true)
        }
        else{

            db.collection("Invoice").document(invoice.invoiceID).setData(["invoiceType":"unpaid"], merge: true)
        }
    }
    
}

extension InvoicesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currInvoice = invoices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as! InvoicesCell
        
        cell.paidButtonStatus(status: currInvoice.paid)
        let dueDate = cell.checkOverdue(invoice: currInvoice)
        cell.setInvoice(invoice: currInvoice,dueDate: dueDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currInvoice = invoices[indexPath.row]
        let url = currInvoice.url
        
        UIApplication.shared.open(URL(string:url)! as URL, options: [:], completionHandler: nil)

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let db = Firestore.firestore()
            let invoice = invoices[indexPath.row]
            // handle delete (by removing the data from your array and updating the tableview)
            tableview.beginUpdates()
            invoices.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath], with: .fade)
            db.collection("Invoice").document(invoice.invoiceID).delete()
            tableview.endUpdates()
        }
    }
    
}
