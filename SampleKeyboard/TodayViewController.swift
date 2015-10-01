//
//  TodayViewController.swift
//  SampleKeyboard
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015年 Alex Chen. All rights reserved.
//

import UIKit
import NotificationCenter
import Core

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var ntLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    var numberString: String = ""
    var currencys: [Currency] = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        loadData()
        getStatus()
    }
    
    
    func loadData() {
        
        for country in CurrencyMap.country {
            
            let isoCode = country.0
            let countryName = country.1
            
            let imageName = ("\(isoCode)_\(countryName)")
            let currency = Currency()
            
            currency.flagImage = UIImage(named: imageName)
            
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
        
        // reorder items
        self.currencys.sortInPlace({ $0.displayName < $1.displayName })
        
        if let item = self.currencys.filter({m in m.isMajor}).first {
            
            if let i = self.currencys.indexOf({m in m.isMajor}) {
                self.currencys.removeAtIndex(i)
            }
            
            let currencyRequest = CurrencyRequest()
            
            if let data = UserDefaultDataService.sharedInstance.getQueryCurrencysDate() {
                currencyRequest.parseCurrency(self.currencys, data: data)
            } else {
                currencyRequest.getCurrency(item.currencyCode, currencys: self.currencys) { (currency) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                    }
                }
            }
        }
    }

    func getStatus(){
        
        
        
        let defaults = NSUserDefaults(suiteName: "group.com.AlexChen.extrmeCurrencyShareData")
       
        let data = defaults!.objectForKey("queryCurrencysDate") as! NSData
        
        let currencyRequest = CurrencyRequest()
        
        currencyRequest.parseCurrency(currencys, data: data)
        
        for currency in currencys {
            print(currency)
        }
        
        /*
        if let test: NSDate = defaults!.objectForKey("queryCurrencysDate"){
            
            ntLabel.text = String(test)
          print(test)
        } else {
             print("No")
            ntLabel.text = "No"
        }*/
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        getStatus()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getCurrency()
    }
    
    func getCurrency(){
        
        let url = NSURL(string: "http://rate-exchange.herokuapp.com/fetchRate?from=JPY&to=TWD")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data!)
            print(json)
            print(json["Rate"].doubleValue)
            
            let aDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            aDefaults.setDouble(json["Rate"].doubleValue, forKey: "Rate")
            aDefaults.setObject(NSDate(), forKey: "Date")
            self.getStatus()
        }
        
        task.resume()
    }
    
    func updatePreferredContentSize() {
        self.preferredContentSize = CGSizeMake(CGFloat(0), CGFloat(400))
    }
    
    @IBAction func clear(sender: AnyObject) {
        self.label.text = "0"
        ntLabel.text = "0"
        numberString = ""
    }
    
    var isEqual = false
    
    @IBAction func equal(sender: AnyObject) {
        
    }
    
    func equal(){
        let yNumber = NSString(string: self.label!.text!).doubleValue
        let aDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let rate = aDefaults.doubleForKey("Rate")
        ntLabel.text = "\(yNumber * rate)"
        isEqual = true
    }
    
    @IBAction func numberTouchUp(sender: AnyObject) {
        
        let str = (sender as! UIButton).titleLabel!.text!
        
        switch str {
        case "." :
            if numberString.containsString(".") {
                return
            }
            break
        case "0":
            if numberString.characters.count == 0 {
                self.label.text = str
                return
            }
            break
        default:
            break
        }
        
        numberString += (sender as! UIButton).titleLabel!.text!
        
        self.label.text = numberString
        
        let yNumber = NSString(string: numberString).doubleValue * 0.2757
        //let aDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        ntLabel.text = NSString(format: "%.02f", yNumber) as String
    }
}

extension Float {
    var toDecimalStyle:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}


