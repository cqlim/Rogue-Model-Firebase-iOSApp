//
//  CalendarViewCell.swift
//  GoingRogueDesign
//
//  Created by Zhang Yuanjun on 4/10/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import UIKit

class CalendarViewCell: UITableViewCell {

    
    @IBOutlet weak var CalendarNameLabel: UILabel!
    
    
    func setCalendar(calendar: Calendar){
        
        CalendarNameLabel.text = calendar.name
    
    }

}
