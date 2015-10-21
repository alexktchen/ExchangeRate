//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015 Alex Chen. All rights reserved.
//

import UIKit
import Core

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var barItemEdit: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topFlagImage: UIImageView!
    @IBOutlet weak var titleView: UIView!

    //var currencys: [Currency] = LoadCountryDataService.sharedInstance.mainCurrencys

    @IBAction func edit(sender: AnyObject) {
        self.tableView.setEditing(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.topFlagImage.layer.cornerRadius = self.topFlagImage.frame.size.width / 2
        self.topFlagImage.clipsToBounds = true
        self.topFlagImage.layer.borderWidth = 2
        self.topFlagImage.layer.borderColor = UIColor.whiteColor().CGColor

        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }

    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Load Data

    /*
    func loadData() {

        currencys = LoadCountryDataService.sharedInstance.allCurrencys
        // reorder items
        self.currencys.sortInPlace({ $0.displayName < $1.displayName })

        if let item = self.currencys.filter({m in m.isMajor}).first {

            if let i = self.currencys.indexOf({m in m.isMajor}) {
                self.currencys.removeAtIndex(i)
            }

            selectItem(item)

            let currencyRequest = CurrencyRequest()

            if let data = UserDefaultDataService.sharedInstance.getQueryCurrencysData() {
                currencyRequest.parseCurrency(self.currencys, data: data)
            } else {
                currencyRequest.getCurrency(item.currencyCode, currencys: self.currencys) { (currency) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            }
            self.tableView.reloadData()
        }
    }*/

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LoadCountryDataService.sharedInstance.mainCurrencys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.displayNameLabel.text = LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row].displayName
        cell.currencyLabel.text = LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row].currencyCode
        cell.symbolLabel.text = LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row].symbol
        cell.flagImage.image = LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row].flagImage
        cell.backgroundColor = UIColor(rgba: "#F5F5F5")
        cell.priceLabel.text = String(1 * LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row].rate)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // Yes, the table view can be reordered
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        let item = LoadCountryDataService.sharedInstance.mainCurrencys[fromIndexPath.row]
        LoadCountryDataService.sharedInstance.mainCurrencys.removeAtIndex(fromIndexPath.row)
        LoadCountryDataService.sharedInstance.mainCurrencys.insert(item, atIndex: toIndexPath.row)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "cell_delete".localized) { action, index in
            LoadCountryDataService.sharedInstance.mainCurrencys.removeAtIndex(indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.endUpdates()
        }
        let set = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "cell_default".localized) { action, index in
            self.selectItem(LoadCountryDataService.sharedInstance.mainCurrencys[indexPath.row])
            self.tableView.setEditing(false, animated: true)
        }
        set.backgroundColor = CustomColors.lightRedColor
        return [set,delete]
    }
    
    
    func selectItem(item: Currency) {
        topFlagImage.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.topFlagImage.image = item.flagImage
            self.topFlagImage.alpha = 1
        })
    }
}

