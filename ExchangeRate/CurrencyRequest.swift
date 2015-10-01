//
//  CurrencyRequest.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/28.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation

class CurrencyRequest: NSObject, NSXMLParserDelegate {
    
    //var currenyAPI = "http://query.yahooapis.com/v1/public/yql?q="
    /*
    http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in ("USDEUR", "USDJPY", "USDBGN", "USDCZK", "USDDKK", "USDGBP", "USDHUF", "USDLTL", "USDLVL", "USDPLN", "USDRON", "USDSEK", "USDCHF", "USDNOK", "USDHRK", "USDRUB", "USDTRY", "USDAUD", "USDBRL", "USDCAD", "USDCNY", "USDHKD", "USDIDR", "USDILS", "USDINR", "USDKRW", "USDMXN", "USDMYR", "USDNZD", "USDPHP", "USDSGD", "USDTHB", "USDZAR", "USDISK")&env=store://datatables.org/alltableswithkeys
    */
    
    /*
    http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in ('USDEUR','USDJPY')&env=store://datatables.org/alltableswithkeys
    */
    
    func getCurrency(majorCode: String, currencys : [Currency], completionHandler: ([Currency]?) -> Void) {
        
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
                    UserDefaultDataService.sharedInstance.setQueryCurrencysDate(d)
                    self.parseCurrency(currencys, data: d)
                    completionHandler(nil)
                }
            }
        }
    }

    func parseCurrency(currencys : [Currency], data: NSData) {
        
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
}