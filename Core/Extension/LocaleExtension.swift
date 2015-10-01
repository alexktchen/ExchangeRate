//
//  NSLocaleExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/29.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation
public extension NSLocale {

    struct Locale {
        let countryCode: String
        let countryName: String
    }

    class func locales() -> [Locale] {
        
        var locales = [Locale]()
        for localeCode in NSLocale.ISOCountryCodes() {
            let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: localeCode)!
            let countryCode = localeCode 
            let locale = Locale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        
        return locales
    }

    class func locales(code: String) -> String? {
        
        let countryName = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value: code)
        return countryName
    }

    class func localesCurrencyCode(code: String) -> String? {
        let dictionary : NSDictionary = NSDictionary(object: code, forKey:NSLocaleCountryCode)
        let identifier : NSString = NSLocale.localeIdentifierFromComponents(dictionary as! [String : String])
        let selectedLocale = NSLocale(localeIdentifier: identifier as String)
        let currencyCode = selectedLocale.objectForKey(NSLocaleCurrencyCode)
        return currencyCode as? String
    }
    
    class func localesCurrencySymbol(code: String) -> String? {
        let dictionary : NSDictionary = NSDictionary(object: code, forKey:NSLocaleCountryCode)
        let identifier : NSString = NSLocale.localeIdentifierFromComponents(dictionary as! [String : String])
        let selectedLocale = NSLocale(localeIdentifier: identifier as String)
        let currencyCode = selectedLocale.objectForKey(NSLocaleCurrencySymbol)
        return currencyCode as? String
    }
}