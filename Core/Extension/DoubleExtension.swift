//
//  DoubleExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/4.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import Foundation

public extension Double {

    var toCurrencyStyle: String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        return formatter.stringFromNumber(self)!.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}