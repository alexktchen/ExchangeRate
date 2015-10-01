//
//  TodayViewController.swift
//  SampleKeyboard
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015年 Alex Chen. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var ntLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    var numberString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        getStatus()
    }
    
    func getStatus(){
        
        let defaults = NSUserDefaults(suiteName: "group.com.seligmanventures.LightAlarmFree")
        defaults!.synchronize()
        
        if let test: NSDate = defaults!.objectForKey("queryCurrencysDate") as? NSDate{
            
            ntLabel.text = String(test)
          print(test)
        } else {
             print("No")
            ntLabel.text = "No"
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
        
        completionHandler(NCUpdateResult.NewData)
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


