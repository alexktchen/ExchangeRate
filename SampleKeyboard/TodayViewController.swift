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
    @IBOutlet weak var statusLabel: UILabel!
    
    var numberString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize()
        getStatus()
    }
    
    func getStatus(){
        
        let aDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
       
        if var date: AnyObject = aDefaults.objectForKey("Date") {
            
            var rate = aDefaults.doubleForKey("Rate")
            var date = aDefaults.objectForKey("Date") as! NSDate
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd HH:mm"
            
            
            var dateString = dateFormatter.stringFromDate(date)
            println(dateString) 
            
            dispatch_async(dispatch_get_main_queue(), {
                self.statusLabel.text = "最後更新時間：\(dateString) 匯率：\(rate)"
            })
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
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
            let json = JSON(data: data)
            println(json)
            println(json["Rate"].doubleValue)
            
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
        numberString = "0"
    }
    
    var isEqual = false
    
    @IBAction func equal(sender: AnyObject) {
        var yNumber = NSString(string: self.label!.text!).doubleValue
        let aDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var rate = aDefaults.doubleForKey("Rate")
        ntLabel.text = "\(yNumber * rate)"
        isEqual = true
    }
    
    @IBAction func numberTouchUp(sender: AnyObject) {
        
        if (isEqual){
           
            isEqual = false
            var s = (sender as! UIButton).titleLabel!.text
            self.label.text = s
            numberString = s!
        } else {
            
            var s = (sender as! UIButton).titleLabel!.text
            if self.label.text == "0" {
                self.numberString = s!
            } else {
                numberString += s!
            }
            self.label.text = numberString
        }

    }
}




