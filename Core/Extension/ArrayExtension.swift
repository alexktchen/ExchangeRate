//
//  ArrayExtension.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/22.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import Foundation

public extension Array {
    func containsReference(obj: AnyObject) -> Bool {
        for ownedItem in self {
            if let ownedObject: AnyObject = ownedItem as? AnyObject {
                if (ownedObject === obj) {
                    return true
                }
            }
        }

        return false
    }
}
