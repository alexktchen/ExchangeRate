//
//  CountryTableView.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/3.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import UIKit
import Core

protocol CountryPassValueDelegate {
    func currenctSelected(aCity: Currency)
}

class CountryFetchTableView: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var delegate: CountryPassValueDelegate?

    var searchActive : Bool = false
    var filtered:[Currency] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
    * Occur when table view was drag
    *:param: scrollView
    */
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }

    // MARK : - Search bar

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.filtered.removeAll()
        self.tableView.reloadData()
    }

    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            searchActive = false
            filtered.removeAll()
            self.tableView.reloadData()
            return
        }

        filtered = LoadCountryDataService.sharedInstance.allCurrencys.filter({ (item) -> Bool in

            var isFound = false

            let countryTmp: NSString = item.currencyCode.lowercaseString
            let countryRange = countryTmp.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let displayNameTmp: NSString = item.displayName.lowercaseString
            let displayNameRange = displayNameTmp.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.CaseInsensitiveSearch)

            if displayNameRange.location != NSNotFound {
                isFound = true
            } else if countryRange.location != NSNotFound {
                isFound = true
            }

            return isFound
        })

        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchActive {
            return filtered.count
        }
        return LoadCountryDataService.sharedInstance.allCurrencys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        if(searchActive) {
            cell.textLabel?.text = filtered[indexPath.row].displayName
        } else {
            cell.textLabel?.text = LoadCountryDataService.sharedInstance.allCurrencys[indexPath.row].displayName
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let item = LoadCountryDataService.sharedInstance.allCurrencys[indexPath.row]

        LoadCountryDataService.sharedInstance.mainCurrencys.append(item)
        LoadCountryDataService.sharedInstance.saveMainCountry()

        //delegate?.currenctSelected(item)
        self.navigationController?.popViewControllerAnimated(true)

    }

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
