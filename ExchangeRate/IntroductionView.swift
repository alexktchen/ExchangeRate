//
//  IntroductionView.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/18.
//  Copyright © 2015年 AlexChen. All rights reserved.
//

import UIKit
import Core

class IntroductionView: UIViewController, MYIntroductionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        introductionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func introductionDidFinishWithType(finishType: MYFinishType) {
        self.navigationController?.navigationBarHidden = false

        self.navigationController?.popToRootViewControllerAnimated(false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        self.navigationController!.pushViewController(mainViewController, animated: true)
    }

    func introductionDidChangeToPanel(panel: MYIntroductionPanel!, withIndex panelIndex: Int) {


    }

    func introductionView() {

        self.navigationController?.navigationBarHidden = true
        let panel = MYIntroductionPanel(withimage: UIImage(named: "SampleImage1"), title: "Sample Title" ,description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")
        let panel2 = MYIntroductionPanel(withimage: UIImage(named: "SampleImage2"), description: "Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!")

        let introductionView = MYIntroductionView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), headerText: "456", panels: [panel, panel2], languageDirection: MYLanguageDirectionLeftToRight)

        introductionView.setBackgroundImage(UIImage(named: "IntroductionBackground"))
        introductionView.delegate = self;
        introductionView.setBackgroundColor(CustomColors.lightRedColor)
        introductionView.BackgroundImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        introductionView.HeaderImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        introductionView.HeaderLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        introductionView.HeaderView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        introductionView.PageControl.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        introductionView.SkipButton.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        introductionView.showInView(self.view, animateDuration: 0.0)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
