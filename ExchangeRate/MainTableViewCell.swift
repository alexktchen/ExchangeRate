//
//  MainTableViewCell.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/24.
//  Copyright © 2015 Alex Chen. All rights reserved.
//

import Foundation
import UIKit
import Core

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    override func drawRect(rect: CGRect) {
        self.flagImage.layer.cornerRadius = self.flagImage.frame.size.width / 2
        self.flagImage.clipsToBounds = true
        self.flagImage.layer.borderWidth = 2.0
        self.flagImage.layer.borderColor = CustomColors.lightGrayColor.CGColor
    }
    
}