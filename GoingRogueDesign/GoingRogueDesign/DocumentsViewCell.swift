//
//  DocumentsViewCell.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class DocumentsViewCell: UITableViewCell {

    @IBOutlet weak var DocumentTitle: UILabel!
            
    @IBOutlet weak var DocumentType: UILabel!
    
    func setDocument(document: Document){
            
        DocumentTitle.text = document.title
        DocumentType.text = document.type
    }
    
}
