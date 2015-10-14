//
//  loadCountryData.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/3.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import Foundation

public class LoadCountryDataService: NSData {
    
    public class var sharedInstance: LoadCountryDataService {
        struct Singleton {
            static let instance = LoadCountryDataService()
        }
        return Singleton.instance
    }

    public var currencys: Array<Currency> = Array<Currency>()

    public func loadCountry() {
        
        for country in CurrencyMap.country {
            
            let isoCode = country.0
            let countryName = country.1
            
            let imageName = ("\(isoCode)_\(countryName)")
            let currency = Currency()
            
            currency.flagImageName = imageName
            currency.flagImage = UIImage(named: imageName)!
            
            if let symbol = NSLocale.localesCurrencySymbol(country.0) {
                currency.symbol = symbol
            }
            
            if let currencyCode = NSLocale.localesCurrencyCode(country.0) {
                currency.currencyCode = currencyCode
            }
            
            if let displayName = NSLocale.locales(country.0) {
                currency.displayName = displayName
            }
            
            if isoCode == "TW" {
                currency.isMajor = true
            } else {
                currency.isMajor = false
            }
            
            currencys.append(currency)
        }
        self.currencys.sortInPlace({ $0.displayName < $1.displayName })
    }
}
