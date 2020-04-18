//
//  HelperFunctions.swift
//  GoingRogueDesign
//
//  Created by Jeff Deng on 3/29/20.
//  Copyright © 2020 Jeff Deng. All rights reserved.
//

import Foundation
import UIKit

// Takes the time stamp and convert to date
func dateConvertToString(date: Date) -> String{
    let df = DateFormatter()
    df.amSymbol = "AM"
    df.pmSymbol = "PM"
    df.dateFormat = "yyyy-MM-dd' at 'hh:mm a"
    return df.string(from: date)
}

// Make part of a text bold. Retrieved from "https://stackoverflow.com/questions/36486761/make-part-of-a-uilabel-bold-in-swift"

func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string,
                                                 attributes: [NSAttributedString.Key.font: font])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}
