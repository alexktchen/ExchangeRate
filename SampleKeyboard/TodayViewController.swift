//
//  TodayViewController.swift
//  SampleKeyboard
//
//  Created by Alex Chen on 2015/9/14.
//  Copyright (c) 2015 Alex Chen. All rights reserved.
//

import UIKit
import NotificationCenter
import Core

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var majorImage: UIImageView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorCurrencyCode: UILabel!
    @IBOutlet weak var majorCurrencySymbol: UILabel!
    @IBOutlet weak var minorImage: UIImageView!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var minorCurrencyCode: UILabel!
    @IBOutlet weak var minorCurrencySymbol: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    var numberString: String = ""
    var currencys: [Currency] = [Currency]()
    var majorCurrency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshButton.layer.cornerRadius = self.refreshButton.frame.size.width / 2
        self.refreshButton.clipsToBounds = true
        self.refreshButton.layer.borderWidth = 1
        self.refreshButton.layer.borderColor = CustomColors.switchGrayColor.CGColor
        updatePreferredContentSize()
    }

    override func viewWillAppear(animated: Bool) {
        adjustUi()
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func refreshButtonUpInside(sender: AnyObject) {
        loadData()
    }


    func loadAnimation() {
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced

        let fullRotation = CGFloat(M_PI * 2)

        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.refreshButton.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.refreshButton.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })

            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.refreshButton.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })

            }, completion: nil)
    }

    func adjustUi() {
        centerView.frame = getCenterViewCGRect(centerView)
        minorLabel.frame = getRightViewCGRect(minorLabel)
        rightView.frame = getRightViewCGRect(rightView)
        keyboardView.frame = getCenterViewCGRect(keyboardView)
        updateTimeLabel.frame = getCenterViewCGRect(updateTimeLabel)
    }

    func getCenterViewCGRect(view: UIView) -> CGRect {
        let centerViewFrame = view.frame
        let centerViewWidth = view.frame.width / 2
        let frameWidth = self.view.frame.width / 2
        return CGRectMake(frameWidth - centerViewWidth, centerViewFrame.origin.y, centerViewFrame.width, centerViewFrame.height)
    }

    func getRightViewCGRect(view: UIView) -> CGRect {
        let frameWidth = self.view.frame.width - 5
        let rightViewFrame = view.frame
        return CGRectMake(frameWidth - rightViewFrame.width , rightViewFrame.origin.y, rightViewFrame.width, rightViewFrame.height)
    }

    func loadData() {

        loadAnimation()

        if let item = UserDefaultDataService.sharedInstance.getMajorCurrencysData() {
            self.majorCurrency = item
            self.majorImage.image = item.flagImage
            self.majorCurrencyCode.text = item.currencyCode
            self.currencys.append(item)
        }

        if let item = UserDefaultDataService.sharedInstance.getMinorCurrencysData() {
            self.minorImage.image = item.flagImage
            self.minorCurrencyCode.text = item.currencyCode
            self.currencys.append(item)
        }

        let currencyRequest = CurrencyRequest()
        currencyRequest.getTodayExtensionCurrency(self.currencys[0].currencyCode, minorCode: self.currencys[1].currencyCode) { (currencys) -> Void in
            self.delay(0.0) {
                self.updateTimeLabel.text = NSDate().toString("yyyy/MM/dd HH:mm")

                if let c = currencys {
                    self.currencys = c
                    self.majorCurrencySymbol.text = "1 \(c[0].symbol) = \(c[0].rate) \(c[1].symbol)"
                    self.minorCurrencySymbol.text = "1 \(c[1].symbol) = \(c[1].rate) \(c[0].symbol)"
                }
            }
        }



    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
        loadData()
    }

    func updatePreferredContentSize() {
        self.preferredContentSize = CGSizeMake(CGFloat(0), CGFloat(400))
    }

    @IBAction func clear(sender: AnyObject) {
        self.majorLabel.text = "0"
        self.minorLabel.text = "0"
        numberString = ""
    }

    @IBAction func numberTouchUp(sender: AnyObject) {
        //adjustUi()
        let str = (sender as! UIButton).titleLabel!.text!

        switch str {
        case "." :
            if numberString.containsString(".") {
                return
            }
            break
        case "0":
            if numberString.characters.count == 0 {
                let majorNum = NSString(string: str).doubleValue

                self.majorLabel.text = majorNum.toCurrencyStyle
                return
            }
            break
        default:
            break
        }

        numberString += (sender as! UIButton).titleLabel!.text!
        let majorNum = NSString(string: numberString).doubleValue
        self.majorLabel.text = majorNum.toCurrencyStyle

        let minorNum = NSString(string: numberString).doubleValue
        let rate = currencys[0].rate
        let number = minorNum * rate
        self.minorLabel.text = number.toCurrencyStyle
    }
}
