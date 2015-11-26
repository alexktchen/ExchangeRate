//
//  Currency.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/25.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation
import UIKit

public class Currency: NSObject, NSCoding {
    
    
    public var displayName: String = ""
    public var dollarsName: String = ""
    public var rate: Double = 0.0
    public var ask: Double = 0.0
    public var bid: Double = 0.0
    public var isMajor: Bool = false
    public var isAddToMain: Bool = false
    public var isAddToMainDefault: Bool = false
    public var symbol: String = ""
    public var dateTime: NSDate?
    public var currencyCode: String = ""
    public var country: String = ""
    public var flagImageName: String?
    public var largeFlagImageName: String?
    public var flagImage: UIImage?
    public var largeFlagImage: UIImage?
    public override init() {

    }

    // MARK: NSCoding
    
    required public init?(coder decoder: NSCoder) {
        
        if let displayName = (decoder.decodeObjectForKey("displayName") as? String) {
            self.displayName = displayName
        }
        
        if let dollarsName = (decoder.decodeObjectForKey("dollarsName") as? String) {
            self.dollarsName = dollarsName
        }
        
        if let rate = (decoder.decodeObjectForKey("rate") as? Double) {
            self.rate = rate
        }
        
        if let ask = (decoder.decodeObjectForKey("ask") as? Double) {
            self.ask = ask
        }
        
        if let bid = (decoder.decodeObjectForKey("bid") as? Double) {
            self.bid = bid
        }
        
        if let isMajor = (decoder.decodeObjectForKey("isMajor") as? Bool) {
            self.isMajor = isMajor
        }

        if let isAddToMain = (decoder.decodeObjectForKey("isAddToMain") as? Bool) {
            self.isAddToMain = isAddToMain
        }

        if let isAddToMainDefault = (decoder.decodeObjectForKey("isAddToMainDefault") as? Bool) {
            self.isAddToMainDefault = isAddToMainDefault
        }


        if let symbol = (decoder.decodeObjectForKey("symbol") as? String) {
            self.symbol = symbol
        }
        
        if let dateTime = (decoder.decodeObjectForKey("dateTime") as? NSDate) {
            self.dateTime = dateTime
        }
        
        if let currencyCode = (decoder.decodeObjectForKey("currencyCode") as? String) {
            self.currencyCode = currencyCode
        }
        
        if let country = (decoder.decodeObjectForKey("country") as? String) {
            self.country = country
        }
    
        if let flagImageName = (decoder.decodeObjectForKey("flagImageName") as? String) {
            self.flagImageName = flagImageName
        }
        
        if let flagImage = (decoder.decodeObjectForKey("flagImage") as? UIImage) {
            self.flagImage = flagImage
        }

        if let largeFlagImageName = (decoder.decodeObjectForKey("largeFlagImageName") as? String) {
            self.largeFlagImageName = largeFlagImageName
        }

        if let largeFlagImage = (decoder.decodeObjectForKey("largeFlagImage") as? UIImage) {
            self.largeFlagImage = largeFlagImage
        }

    }
    
    public func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeObject(self.displayName, forKey: "displayName")
        aCoder.encodeObject(self.dollarsName, forKey: "dollarsName")
        aCoder.encodeObject(self.rate, forKey: "rate")
        aCoder.encodeObject(self.ask, forKey: "ask")
        aCoder.encodeObject(self.bid, forKey: "bid")
        aCoder.encodeObject(self.isMajor, forKey: "isMajor")
        aCoder.encodeObject(self.isAddToMain, forKey: "isAddToMain")
        aCoder.encodeObject(self.isAddToMainDefault, forKey: "isAddToMainDefault")
        aCoder.encodeObject(self.symbol, forKey: "symbol")
        aCoder.encodeObject(self.currencyCode, forKey: "currencyCode")
        aCoder.encodeObject(self.dateTime, forKey: "dateTime")
        aCoder.encodeObject(self.country, forKey: "country")
        aCoder.encodeObject(self.flagImageName, forKey: "flagImageName")
        aCoder.encodeObject(self.flagImage, forKey: "flagImage")
        aCoder.encodeObject(self.largeFlagImageName, forKey: "largeFlagImageName")
        aCoder.encodeObject(self.largeFlagImage, forKey: "largeFlagImage")
    }
    
}