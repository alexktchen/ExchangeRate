//
//  UserDefaultDataService.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/30.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation

public class UserDefaultDataService {

    public static let sharedInstance = UserDefaultDataService()
    
    let aDefaults:NSUserDefaults!
    let queryCurrencysData = "queryCurrencysData"
    let majorCurrencysData = "majorCurrencysData"
    let minorCurrencysData = "minorCurrencysData"
    let ExCurrencysData = "ExCurrencysData"
    init() {
        aDefaults = NSUserDefaults(suiteName: "group.com.AlexChen.extrmeCurrencyShareData")  
    }

    // set today extension of Currencys Data
    public func setExCurrencysData(aData: NSData) {
        aDefaults.setObject(aData, forKey: ExCurrencysData)
        aDefaults.synchronize()
    }

    // get today extension of Currencys Data
    public func getExCurrencysData() -> NSData? {
        return aDefaults.objectForKey(ExCurrencysData) as? NSData
    }

    public func setQueryCurrencysData(aData: NSData) {
        aDefaults.setObject(aData, forKey: queryCurrencysData)
        aDefaults.synchronize()
    }

    public func getQueryCurrencysData() -> NSData? {
        return aDefaults.objectForKey(queryCurrencysData) as? NSData
    }
    
    public func setMajorCurrencysData(aCurrency: Currency) {
        
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(aCurrency)
        aDefaults.setObject(encodedObject, forKey: majorCurrencysData)
        aDefaults.synchronize()
    }
    
    public func getMajorCurrencysData() -> Currency? {
        aDefaults.synchronize()
        if let encodedObject = aDefaults.objectForKey(majorCurrencysData) as? NSData {
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject)
            return object as? Currency
        } else {
            return nil
        }
    }

    public func setMinorCurrencysData(aCurrency: Currency) {
       
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(aCurrency)
        aDefaults.setObject(encodedObject, forKey: minorCurrencysData)
        aDefaults.synchronize()
    }

    public func getMinorCurrencysData() -> Currency? {
        aDefaults.synchronize()
        if let encodedObject = aDefaults.objectForKey(minorCurrencysData) as? NSData {
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject)
            aDefaults.synchronize()
            return object as? Currency
        } else {
            return nil
        }
    }

}