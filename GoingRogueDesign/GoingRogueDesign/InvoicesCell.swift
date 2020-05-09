//
//  InvoicesCell.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 3/30/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class InvoicesCell: UITableViewCell {


    @IBOutlet weak var InvoiceNameLabel: UILabel!
    @IBOutlet weak var InvoiceDueLabel: UILabel!
    @IBOutlet weak var InvoicePaidButton: UIButton!
    
    
    func setInvoice(invoice: Invoice, dueDate: NSAttributedString){
        
        InvoiceNameLabel.text = invoice.name
        InvoiceDueLabel.attributedText = dueDate
    }
    
    // sets the paid button's state when launch the invoice view
    func paidButtonStatus(status: String){
        if(status == "paid"){
            InvoicePaidButton.isSelected = true
        }
        else{
            InvoicePaidButton.isSelected = false
        }
    }
    
    // use a red-colored string if it's unpaid past the due date
    func checkOverdue(invoice: Invoice) -> NSAttributedString{
        let currentDateTime = Date()
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        
        attributes[.foregroundColor] = UIColor.red

        var attributedString = NSAttributedString(string: invoice.dueDate)

        if((currentDateTime > invoice.dueDateForChecking) && (invoice.paid == "unpaid") ){

             attributedString = NSAttributedString(string: invoice.dueDate, attributes: attributes)

        }
        
        
        return attributedString
    }
}
