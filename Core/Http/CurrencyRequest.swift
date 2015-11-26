//
//  CurrencyRequest.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/28.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation
//*
public class CurrencyRequest: NSObject, NSXMLParserDelegate {

    //var currenyAPI = "http://query.yahooapis.com/v1/public/yql?q="
    /*
    http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in ("USDEUR", "USDJPY", "USDBGN", "USDCZK", "USDDKK", "USDGBP", "USDHUF", "USDLTL", "USDLVL", "USDPLN", "USDRON", "USDSEK", "USDCHF", "USDNOK", "USDHRK", "USDRUB", "USDTRY", "USDAUD", "USDBRL", "USDCAD", "USDCNY", "USDHKD", "USDIDR", "USDILS", "USDINR", "USDKRW", "USDMXN", "USDMYR", "USDNZD", "USDPHP", "USDSGD", "USDTHB", "USDZAR", "USDISK")&env=store://datatables.org/alltableswithkeys
    */

    /*
    http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in ('USDEUR','USDJPY')&env=store://datatables.org/alltableswithkeys
    */

    public func getCurrency(majorCode: String, currencys : [Currency], completionHandler: ([Currency]?) -> Void) {

        var currencysString = ""
        var filerCurrencyCode: [String] = []

        for item in currencys {

            if !filerCurrencyCode.contains(item.currencyCode) {
                filerCurrencyCode.append(item.currencyCode)
            }
        }

        for item in filerCurrencyCode {
            currencysString += "'\(majorCode)\(item)', "
        }

        currencysString = (currencysString as NSString).substringToIndex(currencysString.characters.count - 2)

        let currenyAPI = "http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (\(currencysString))&env=store://datatables.org/alltableswithkeys"

        let baseRequest = BaseRequest()
        baseRequest.request(currenyAPI) { (data, error) -> Void in

            if error == nil && data != nil {
                if let d = data {
                    UserDefaultDataService.sharedInstance.setQueryCurrencysData(d)
                    self.parseCurrency(currencys, data: d)
                    completionHandler(nil)
                }
            }
        }
    }

    public func getTodayExtensionCurrency(majorCode: String, minorCode : String, completionHandler: ([Currency]?) -> Void) {

        let currencysString = "'\(majorCode)\(minorCode)', '\(minorCode)\(majorCode)'"

        let currenyAPI = "http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (\(currencysString))&env=store://datatables.org/alltableswithkeys"

        let baseRequest = BaseRequest()
        baseRequest.request(currenyAPI) { (data, error) -> Void in

            if error == nil && data != nil {
                if let d = data {
                    UserDefaultDataService.sharedInstance.setExCurrencysData(d)
                    completionHandler(self.parseTodayExtensionCurrency(d))
                }
            }
        }
    }

    public func parseCurrency(currencys : [Currency], data: NSData) {

        do {
            let xmlDoc = try AEXMLDocument(xmlData: data)
            print(xmlDoc.xmlString)

            if let rates = xmlDoc.root["results"]["rate"].all {

                for rate in rates {

                    if let id = rate.attributes["id"] {

                        let currency = currencys.filter({m in id.rangeOfString(m.currencyCode) != nil })

                        for c in currency {

                            c.dollarsName = rate["Name"].stringValue

                            c.rate = rate["Rate"].doubleValue

                            c.ask = rate["Ask"].doubleValue

                            c.bid = rate["Bid"].doubleValue

                            c.dateTime = NSDate()
                        }
                    }
                }
            }
        }
        catch {
            print("\(error)")
        }
    }

    public func parseTodayExtensionCurrency(data: NSData) -> [Currency] {

        var currencys = [Currency]()

        do {

            let xmlDoc = try AEXMLDocument(xmlData: data)
            print(xmlDoc.xmlString)

            if let rates = xmlDoc.root["results"]["rate"].all {

                for rate in rates {

                    if let _ = rate.attributes["id"] {

                        let currency: Currency = Currency()
                        currency.dollarsName = rate["Name"].stringValue

                        currency.rate = rate["Rate"].doubleValue

                        currency.ask = rate["Ask"].doubleValue

                        currency.bid = rate["Bid"].doubleValue

                        currency.dateTime = NSDate()
                        currencys.append(currency)
                    }
                }
            }
            return currencys
        }
        catch {
            return currencys
        }
    }
}