//
//  TodayViewController.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/3.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import UIKit
import Core

class TodaySettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CountryPassValueDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var isMajor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "today_view_title".localized
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currenctSelected(aCurrency: Currency) {
        
        if isMajor {
            UserDefaultDataService.sharedInstance.setMajorCurrencysData(aCurrency)
        } else {
            UserDefaultDataService.sharedInstance.setMinorCurrencysData(aCurrency)
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.row == 0{
            if let item = UserDefaultDataService.sharedInstance.getMajorCurrencysData() {
                cell.textLabel?.text = "主要貨幣"
                cell.detailTextLabel?.text = item.displayName
            }
        } else {
            if let item = UserDefaultDataService.sharedInstance.getMinorCurrencysData() {
                cell.textLabel?.text = "次要貨幣"
                cell.detailTextLabel?.text = item.displayName
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            isMajor = true
        } else {
            isMajor = false
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginWebView = storyboard.instantiateViewControllerWithIdentifier("CountryFetchTableView") as! CountryFetchTableView
        loginWebView.delegate = self
        self.navigationController!.pushViewController(loginWebView, animated: true)
    }
}
