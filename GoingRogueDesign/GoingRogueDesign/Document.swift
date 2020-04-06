//
//  Document.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/28/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

class Document {
    var title: String
    var type: String
    var url: String
    
    init(title: String, type: String, url: String) {
        self.title = title
        self.type = type
        self.url = url
    }
    
}
