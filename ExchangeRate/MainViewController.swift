//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015 Alex Chen. All rights reserved.
//

import UIKit
import Core

class MainViewController: UITableViewController {

    @IBOutlet weak var titleView: UIView!
    var pathCover: XHPathCover?
    var tableViewHeader: KTTableViewHeader?
    var pieChart: CircleProgressView?
    let pieChartWidth: CGFloat = 30

    let refresh: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")

        refresh.backgroundColor = UIColor.clearColor()
        refresh.tintColor = UIColor.clearColor()

        let x = (self.view.frame.size.width / 2) - (pieChartWidth / 2)
        pieChart = CircleProgressView(frame: CGRectMake(x , 10, pieChartWidth, pieChartWidth))
        pieChart?.backgroundColor = UIColor.clearColor()
        refresh.addSubview(pieChart!)
        self.tableView.addSubview(refresh)

        let filteredDefault = LoadCountryDataService.sharedInstance.allCurrencys.filter {
            $0.isAddToMainDefault == true && $0.isAddToMainDefault == true
        }

        /*
        pathCover = XHPathCover(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 140))
        pathCover!.setBackgroundImage(UIImage(named: "IntroductionBackground"))
        pathCover!.setInfo([XHUserNameKey: "123" , XHBirthdayKey: "13123123123"])
        pathCover!.isZoomingEffect = false
*/
        tableViewHeader = KTTableViewHeader(frame:  CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 140))
        tableViewHeader!.setBackgroundImage(UIImage(named: "IntroductionBackground")!)
        if filteredDefault.count > 0 {
            self.selectItem(filteredDefault[0])
            self.tableView.setEditing(false, animated: true)
            self.tableView.tableHeaderView = self.tableViewHeader
        }
    }


    override func viewWillAppear(animated: Bool) {
        //self.tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        //stretchableTableHeaderView.resizeView()
        // stretchableTableHeaderView1.resizeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // pragma mark - scroll delegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        tableViewHeader!.scrollViewDidScroll(scrollView)

        let systemVersionDouble: Double? = Double(UIDevice.currentDevice().systemVersion)

        var fixAdaptorPadding = CGFloat(0)
        if systemVersionDouble >= 7.0 {
            fixAdaptorPadding = 64
        }

        var offsetY = scrollView.contentOffset.y * 1.5
        offsetY += fixAdaptorPadding


        let percent = (-offsetY / (200 * 1))
        if -offsetY > 0 && !isAnimating{
            print(percent)
            if percent >= 1 {
                self.isAnimating = true
            }
            self.pieChart?.progress = Double(percent)
        }
    }

    var isAnimating = false
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        tableViewHeader!.scrollViewDidEndDecelerating(scrollView)
        //pathCover!.scrollViewDidEndDecelerating(scrollView)

        if refresh.refreshing {
           // if !isAnimating {
              //  doSomething()
              //  animateRefreshStep1()
            //}
        } else {

            isAnimating = false
        }
    }

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refresh.refreshing {
            // if !isAnimating {
            //  doSomething()
            //  animateRefreshStep1()
            //}
        } else {
            isAnimating = false
        }
    }

    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        //pathCover!.scrollViewWillBeginDragging(scrollView)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let filtered = LoadCountryDataService.sharedInstance.allCurrencys.filter {$0.isAddToMain == true}

        return filtered.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let filtered = LoadCountryDataService.sharedInstance.allCurrencys.filter {$0.isAddToMain == true}
        let cell: MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell
        cell.displayNameLabel.text = filtered[indexPath.row].displayName
        cell.currencyLabel.text = filtered[indexPath.row].currencyCode
        cell.symbolLabel.text = filtered[indexPath.row].symbol
        cell.flagImage.image = filtered[indexPath.row].flagImage
        cell.backgroundColor = UIColor(rgba: "#F5F5F5")
        cell.priceLabel.text = String(1 * filtered[indexPath.row].rate)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // Yes, the table view can be reordered
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.

        let filtered = LoadCountryDataService.sharedInstance.allCurrencys.filter {$0.isAddToMain == true}
        let item = filtered[fromIndexPath.row]
        LoadCountryDataService.sharedInstance.allCurrencys.removeAtIndex(fromIndexPath.row)
        LoadCountryDataService.sharedInstance.allCurrencys.insert(item, atIndex: toIndexPath.row)
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        var filtered = LoadCountryDataService.sharedInstance.allCurrencys.filter {$0.isAddToMain == true}

        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "cell_delete".localized) { action, index in

            filtered[index.row].isAddToMain = false
            LoadCountryDataService.sharedInstance.saveMainCountry()
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.endUpdates()
        }

        let set = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "cell_default".localized) { action, index in

            var filteredDefault = LoadCountryDataService.sharedInstance.allCurrencys.filter {
                $0.isAddToMainDefault == true && $0.isAddToMainDefault == true
            }

            if filteredDefault.count > 0 {
                filteredDefault[0].isAddToMainDefault = false
            }

            filtered[index.row].isAddToMainDefault = true
            self.selectItem(filtered[indexPath.row])
            LoadCountryDataService.sharedInstance.saveMainCountry()
            self.tableView.setEditing(false, animated: true)
        }
        
        set.backgroundColor = CustomColors.lightRedColor
        return [set,delete]
    }
    
    func selectItem(item: Currency) {
        UIView.animateWithDuration(0.3, animations: {
            self.tableViewHeader!.setAvatarImage(UIImage(named: item.largeFlagImageName!)!)
        })
    }
}

