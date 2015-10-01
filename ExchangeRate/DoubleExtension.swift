//
//  FloatExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/24.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation

extension Float {
    var toDecimalStyle:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}