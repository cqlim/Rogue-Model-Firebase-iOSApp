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
                        let uploadDateString = self.dateConvertToString(date: uploadDateTimeStamp.dateValue())
                        
                        
                        
                        let invoice = Invoice(dueDate: uploadDateString, url: currentInvoice.get("invoiceLink") as? String ?? "N/A", name: currentInvoice.get("invoiceName") as? String ?? "N/A", type: (currentInvoice.get("invoiceType") as? String)!, projectID: currentInvoice.get("projectID") as? String ?? "N/A")
                        
                        self.invoices.append(invoice)
                        print("Project Name: \(invoice.name)")
                    }
                        
                    self.tableview.reloadData()
                }
        }
    }
    
    
    // Takes the time stamp and convert to date
    func dateConvertToString(date: Date) -> String{
        let df = DateFormatter()
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        df.dateFormat = "yyyy-MM-dd' at 'hh:mm a"
        return df.string(from: date)
    }


}

extension InvoicesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currInvoice = invoices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceCell") as! InvoicesCell
        
        cell.setInvoice(invoice: currInvoice)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currInvoice = invoices[indexPath.row]
        let url = currInvoice.url
        
        UIApplication.shared.open(URL(string:url)! as URL, options: [:], completionHandler: nil)

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
