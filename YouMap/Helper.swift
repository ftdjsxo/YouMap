//
//  File.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import UIKit

class Helper {
    static let UNPARSED_ELEMENTS_KEY = "elementsParsed"
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor? {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func searchTitles(pins: [Pin], text: String) -> [Pin]{
        var results = [Pin]()
        for pin in pins{
            if pin.getTitle().lowercaseString.containsString(text.lowercaseString){
                print(pin.getTitle())
                results.append(pin)
            }
        }
        return results
    }

}
