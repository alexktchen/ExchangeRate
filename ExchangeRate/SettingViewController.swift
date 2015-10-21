//
//  SettingViewController.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/3.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "setting_view_title".localized

        //self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor.whiteColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 40
        if scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        view.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)


        if section == 0 {
            let margin = self.tableView.frame.size.width / 2 / 2

            let label = UILabel(frame: CGRectMake(20, 0, self.tableView.frame.size.width - margin, 30))
            view.contentView.addSubview(label)
            label.numberOfLines = 0
            label.textColor = UIColor.lightGrayColor()
            label.userInteractionEnabled = true

            label.textAlignment = NSTextAlignment.Left

            label.font = UIFont(name: label.font.fontName, size: 12)
            label.text = "開啟當地貨幣或依據您的地理位置資訊來顯示所處的國家貨幣．"
        } else {

            let label = UILabel(frame: CGRectMake(10, 0, self.tableView.frame.size.width, 30))
            view.contentView.addSubview(label)
            label.numberOfLines = 0
            label.textColor = UIColor.lightGrayColor()
            label.userInteractionEnabled = true
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: label.font.fontName, size: 12)
            label.text = "資料來源為 Yahoo Finance．"
        }

        return view
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0 {
            return 80
        } else {
            return 200
        }

    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

    // Configure the cell...

    return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
