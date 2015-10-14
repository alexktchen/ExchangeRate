//
//  NSDateExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/14.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import Foundation
public extension NSDate {

    func toString(format: String) -> String? {
        //format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.stringFromDate(self)
        return dateString
    }
}