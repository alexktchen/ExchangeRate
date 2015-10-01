//
//  BackgroundHighlightedButton.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/22.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation
import UIKit

class BackgroundHighlightedButton: UIButton {
    
    
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    
    override var highlighted :Bool {
        get {
            return super.highlighted
        }
        set {
            
            if newValue {
                self.backgroundColor = self.highlightedBackgroundColor
            }
            else {
                self.backgroundColor = self.nonHighlightedBackgroundColor
                
            }
            super.highlighted = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = self.bounds.size.width/2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor =  UIColor.whiteColor().CGColor
        self.titleLabel!.alpha = 1.0
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
    }
    
}