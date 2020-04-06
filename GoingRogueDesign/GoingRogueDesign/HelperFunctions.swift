//
//  HelperFunctions.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/29/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation

// Takes the time stamp and convert to date
func dateConvertToString(date: Date) -> String{
    let df = DateFormatter()
    df.amSymbol = "AM"
    df.pmSymbol = "PM"
    df.dateFormat = "yyyy-MM-dd' at 'hh:mm a"
    return df.string(from: date)
}
