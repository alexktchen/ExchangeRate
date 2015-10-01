//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015 Alex Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var barItemEdit: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topFlagImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    
    var currencys: [Currency] = [Currency]()
    
    @IBAction func edit(sender: AnyObject) {
        self.tableView.setEditing(true, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topFlagImage.layer.cornerRadius = self.topFlagImage.frame.size.width / 2
        self.topFlagImage.clipsToBounds = true
        self.topFlagImage.layer.borderWidth = 2
        self.topFlagImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        
        loadData()
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

            selectItem(item)

            let currencyRequest = CurrencyRequest()

            if let data = UserDefaultDataService.sharedInstance.getQueryCurrencysDate() {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencys.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell
        
        cell.displayNameLabel.text = currencys[indexPath.row].displayName
        cell.currencyLabel.text = currencys[indexPath.row].currencyCode
        cell.symbolLabel.text = currencys[indexPath.row].symbol
        cell.flagImage.image = currencys[indexPath.row].flagImage
        cell.backgroundColor = UIColor(rgba: "#F5F5F5")
        
        if let r = currencys[indexPath.row].rate {
            cell.priceLabel.text = String(1 * r)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectItem(self.currencys[indexPath.row])
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // Yes, the table view can be reordered
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        let item = currencys[fromIndexPath.row]
        currencys.removeAtIndex(fromIndexPath.row)
        currencys.insert(item, atIndex: toIndexPath.row)
    }
    
    func selectItem(item: Currency) {
        topFlagImage.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.topFlagImage.image = item.flagImage
            self.topFlagImage.alpha = 1
        })
    }
}

