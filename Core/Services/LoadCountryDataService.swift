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

    public var allCurrencys: Array<Currency> = Array<Currency>()

    public var mainCurrencys: Array<Currency> = Array<Currency>()

    override init() {
        super.init()
        if let items = UserDefaultDataService.sharedInstance.getMainCurrencysData() {
            mainCurrencys = items
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    public func saveMainCountry() {
        UserDefaultDataService.sharedInstance.removeMainCurrencysData()
        UserDefaultDataService.sharedInstance.setMainCurrencysData(self.mainCurrencys)
    }

    public func loadCountry() {
        
        for country in CurrencyMap.country {
            
            let isoCode = country.0
            let countryName = country.1
            
            let imageName = ("\(isoCode)_\(countryName)")
            let currency = Currency()
            let largeImageName = "\(imageName)_large"
            currency.flagImageName = imageName
            currency.largeFlagImageName = largeImageName
            currency.flagImage = UIImage(named: imageName)!
            currency.largeFlagImage = UIImage(named: largeImageName)!

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
            
            allCurrencys.append(currency)
        }
        allCurrencys.sortInPlace({ $0.displayName < $1.displayName })
    }
}
