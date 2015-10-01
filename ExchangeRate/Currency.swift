//
//  Currency.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/25.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation
import UIKit

class Currency: NSObject {
    
    var dateTime: NSDate?
    var dollarsName: String = ""
    var rate: Double?
    var ask: Double?
    var bid: Double?
    
    
    var isMajor: Bool = false
    
    var price: String = ""
    var symbol: String = ""
    var ts: String = ""
    var type: String = ""
    var utctime: String = ""
    var volume: String = ""
    
    var displayName: String = ""
    var currencyCode: String = ""
    
    var country: String = ""
    var flagImage: UIImage?
    
    
}