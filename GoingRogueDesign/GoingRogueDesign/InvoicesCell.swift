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
    
    
    @IBOutlet weak var InvoiceTypeLabel: UILabel!
    
    func setInvoice(invoice: Invoice){
        
        InvoiceNameLabel.text = invoice.name
        InvoiceTypeLabel.text = invoice.type
    
    }
    
}
