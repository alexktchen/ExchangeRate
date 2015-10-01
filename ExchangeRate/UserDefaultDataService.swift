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
    let queryCurrencysDate = "queryCurrencysDate"

    init() {
        aDefaults = NSUserDefaults(suiteName: "group.com.seligmanventures.LightAlarmFree")  
    }

    public func setQueryCurrencysDate(aData: NSData) {
        aDefaults.setObject(aData, forKey: queryCurrencysDate)
        aDefaults.synchronize()
    }

    public func getQueryCurrencysDate() -> NSData? {
        return aDefaults.objectForKey(queryCurrencysDate) as? NSData
    }
}