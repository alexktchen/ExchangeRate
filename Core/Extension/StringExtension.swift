//
//  StringExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/30.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation

public extension String {
    
    func URLEncodedString() -> String? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        return escapedString
    }
}