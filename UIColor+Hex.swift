//
//  UIColor+Hex.swift
//  Gist
//
//  Created by Alexander Havermale on 5/26/17.
//  Copyright © 2017 Alex Havermale. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     Initializes and returns a color object using the specified opacity and hexidecimal color code.
     
     - Parameters:
        - hexString: The RGB value of the color object, represented as a hexidecimal string. This value may include all six hexidecimal digits, or an abbreviated, three-digit shorthand form, and may optionally contain a preceeding number sign (`#`). Any other values will result in a failed initialization.
        - alpha:     The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0. **The default value is 1.0.**
     
     - Returns: The color object, if one could be initialized from the given `hexString`, or `nil` otherwise. The color information represented by this object is in the same RGB colorspace assigned by the [init(red:green:blue:alpha:)](apple-reference-documentation://hs-s777Fe4) initializer.
     */
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        
        // Check for the right characters in the string parameter:
        guard let regex = try? NSRegularExpression(pattern: "^#?[0-9a-fA-F]{3,6}") else { return nil }
        guard regex.numberOfMatches(in: hexString, range: NSMakeRange(0, hexString.characters.count)) == 1 else { return nil } // print("hexString parameter does not meet prerequisites.")
        
        // Get the string value without the pound symbol:
        let hex = hexString.hasPrefix("#") ? hexString.trimmingCharacters(in: ["#"]) : hexString
        
        var isShorthand: Bool // Used to indicate whether there are only three characters used in the hex string.
        switch hex.characters.count {
            case 3: isShorthand = true
            case 6: isShorthand = false
            default: return nil // print("Cannot parse hexString: parameter value must contain exactly three or six hexidecimal digits.")
        }
        
        let offset = isShorthand ? 1 : 2 // Get the right character(s) in the hex string depending on whether shorthand is used.
        let rIndex = hex.index(hex.startIndex, offsetBy: offset)
        let gIndex = hex.index(hex.startIndex, offsetBy: offset * 2)
        let bIndex = hex.index(hex.startIndex, offsetBy: offset * 3)
        
        let count = isShorthand ? 2 : 1 // Duplicate the hex value's character if shorthand is used.
        let rStr = String(repeating: hex[hex.startIndex..<rIndex], count: count)
        let gStr = String(repeating: hex[rIndex..<gIndex], count: count)
        let bStr = String(repeating: hex[gIndex..<bIndex], count: count)
        
        let r = UInt8(rStr, radix: 16)
        let g = UInt8(gStr, radix: 16)
        let b = UInt8(bStr, radix: 16)

        guard r != nil, b != nil, g != nil else { return nil } // print("Unable to convert hex string values to 8-bit unsigned integer values.")
        
        self.init(red: CGFloat(r!) / 255, green: CGFloat(g!) / 255, blue: CGFloat(b!) / 255, alpha: alpha)
    }
}
