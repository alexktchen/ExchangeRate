//
//  Currency.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/25.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation
import UIKit

public class Currency: NSObject {
    
    public var dateTime: NSDate?
    public var dollarsName: String = ""
    public var rate: Double?
    public var ask: Double?
    public var bid: Double?
    
    
    public var isMajor: Bool = false
    
    public var price: String = ""
    public var symbol: String = ""
    public var ts: String = ""
    public var type: String = ""
    public var utctime: String = ""
    public var volume: String = ""
    
    public var displayName: String = ""
    public var currencyCode: String = ""
    
    public var country: String = ""
    public var flagImage: UIImage?
    
    
}