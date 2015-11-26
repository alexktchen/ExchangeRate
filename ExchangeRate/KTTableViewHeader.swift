//
//  KTTableViewHeader.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/25.
//  Copyright © 2015 AlexChen. All rights reserved.
//


import UIKit
import Core

class KTTableViewHeader: UIView {

    var parallaxHeight: CGFloat = 170.0
    var lightEffectPadding: CGFloat = 200.0
    var lightEffectAlpha:CGFloat = 1

    var bannerView: UIView?
    var showView: UIView?

    var avatarButton: UIButton?

    let avatarButtonHeight: CGFloat = 100.0
    var showUserInfoViewOffsetHeight: CGFloat = 0.0

    var bannerImageView: UIImageView?
    var bannerImageViewWithImageEffects: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {

        self.showUserInfoViewOffsetHeight = CGRectGetHeight(self.frame) - 100 / 3 - 100;

        self.bannerView = UIView(frame: self.bounds)
        self.bannerView?.clipsToBounds = true

        self.bannerImageView = UIImageView(frame: CGRectMake(0,0, CGRectGetWidth(self.bannerView!.frame), CGRectGetHeight(self.bannerView!.frame) + 400))
        self.bannerImageView!.contentMode = UIViewContentMode.ScaleToFill
        self.bannerImageViewWithImageEffects = UIImageView(frame: self.bannerImageView!.frame)
        self.bannerImageViewWithImageEffects!.alpha = 0
        self.avatarButton = UIButton(frame: CGRectMake(15, 0, avatarButtonHeight, avatarButtonHeight))
        self.showView = UIView(frame: CGRectMake(0, self.showUserInfoViewOffsetHeight, CGRectGetWidth(self.bounds), 100))
        self.showView!.backgroundColor = UIColor.clearColor()
        self.showView?.addSubview(self.avatarButton!)
        self.bannerView?.addSubview(self.bannerImageView!)
        self.bannerView?.addSubview(self.bannerImageViewWithImageEffects!)
        self.addSubview(self.bannerView!)
        self.addSubview(self.showView!)
    }

    func setAvatarImage(avatarImage: UIImage) {

        if let avatar = self.avatarButton {
            avatar.setImage(avatarImage, forState: UIControlState.Normal)
            avatar.layer.cornerRadius = (avatar.frame.size.width / 2)
            avatar.clipsToBounds = true
            avatar.layer.borderWidth = 2.0
            avatar.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }

    func setBackgroundImage(backgroundImage: UIImage) {
        bannerImageView!.image = backgroundImage
        bannerImageViewWithImageEffects!.image = backgroundImage.applyLightEffect
    }

    func setOffsetY(var offsetY: CGFloat) {


        var fixAdaptorPadding: CGFloat = 0

        let bannerSuper = self.bannerImageView!.superview
        var bframe = bannerSuper!.frame

        let systemVersionDouble: Double? = Double(UIDevice.currentDevice().systemVersion)

        if systemVersionDouble >= 7.0 {
            fixAdaptorPadding = 64
        }

        offsetY += fixAdaptorPadding

        var frame =  self.showView!.frame

        if offsetY < 0 {
            frame.origin.y = self.showUserInfoViewOffsetHeight
            bframe.origin.y = offsetY
            bframe.size.height = -offsetY + bannerSuper!.superview!.frame.size.height
            bannerSuper!.frame = bframe

            var center =  self.bannerImageView!.center;
            center.y = bannerSuper!.frame.size.height / 2;
            self.bannerImageView!.center = center;

        } else {
            if frame.origin.y != self.showUserInfoViewOffsetHeight {
                frame.origin.y = self.showUserInfoViewOffsetHeight
                self.showView!.frame = frame
            }

            if(bframe.origin.y != 0) {
                bframe.origin.y = 0;
                bframe.size.height = bannerSuper!.superview!.frame.size.height
                bannerSuper!.frame = bframe
            }
            if(offsetY < bframe.size.height) {
                var center =  self.bannerImageView!.center
                center.y = bannerSuper!.frame.size.height / 2 + 0.5 * offsetY
                self.bannerImageView!.center = center
            }
        }

        if (offsetY < 0 && offsetY >= -self.lightEffectPadding) {
            let percent = (-offsetY / (self.lightEffectPadding * self.lightEffectAlpha))
            self.bannerImageViewWithImageEffects!.alpha = percent


        } else if offsetY <= -self.lightEffectPadding {
            self.bannerImageViewWithImageEffects!.alpha = self.lightEffectPadding / (self.lightEffectPadding * self.lightEffectAlpha)
        } else if offsetY > self.lightEffectPadding {
            self.bannerImageViewWithImageEffects!.alpha = 0
        }
    }

    private lazy var outerCircleView = UIView()
    private let outerCircle = CAShapeLayer()

    func create() {

        outerCircleView.frame.size = (self.avatarButton?.frame.size)!

        let circle = (self.avatarButton?.frame.width)!

        outerCircle.path = UIBezierPath(ovalInRect: CGRect(x: 0.0, y: 0.0, width: circle, height: circle)).CGPath
        outerCircle.lineWidth = 3.0
        outerCircle.strokeStart = 0.1
        outerCircle.strokeEnd = 1.0
        outerCircle.lineCap = kCALineCapRound
        outerCircle.fillColor = UIColor.clearColor().CGColor
        outerCircle.strokeColor = UIColor.redColor().CGColor
        outerCircleView.layer.addSublayer(outerCircle)

        self.avatarButton!.addSubview(outerCircleView)

    }
    


    func setProgress(progress: CGFloat) {

        if progress > 0 {

           // pieChart?.progress = Double(progress)

/*
            // some initial values
            CGFloat angle = degToRad(-90);
            CGPoint center = CGPointMake(layer.frame.size.width/2.0, layer.frame.size.width/2.0);
            CGFloat radius = layer.frame.size.width/2.0;

            //Creating a pie using UIBezierPath
            UIBezierPath *piePath = [UIBezierPath bezierPath];
            [piePath moveToPoint:center];
            [piePath addLineToPoint:CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle))];
            [piePath addArcWithCenter:center radius:radius startAngle:angle endAngle:degToRad(degrees-90) clockwise:YES];
            [piePath addLineToPoint:center];
            [piePath closePath]; // this will automatically add a straight line to the center
            
            layer.path = piePath.CGPath; /
*/

            /*
            let startAngle = 1 * CGFloat(M_PI_2)

            let endAngle = 3 * CGFloat(M_PI_2) + 2 * CGFloat(M_PI)
            self.outerCircle.lineWidth = 3
            let point = CGPointMake(CGRectGetMidX(self.avatarButton!.bounds), CGRectGetMidY(self.avatarButton!.bounds))

            self.outerCircle.path = UIBezierPath(arcCenter: point,
                radius: self.avatarButton!.bounds.size.width/2 - 2,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true).CGPath

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = nil
            animation.toValue = progress
            animation.duration = 1
            self.outerCircle.strokeEnd = progress
            self.outerCircle.addAnimation(animation, forKey: "animation")
*/
        } else {

            //self.outerCircle.removeAnimationForKey("animation")
        }
    }

    func animationButton() {

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1.08
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.35
        strokeStartAnimation.duration = 1.4
        self.avatarButton?.layer.addAnimation(strokeStartAnimation, forKey:"rotationAnimation")

        let strokEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokEndAnimation.fromValue = 0
        strokEndAnimation.toValue = 1.08
        strokEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokEndAnimation.beginTime = CACurrentMediaTime() + 0.35 + 1.4
        strokEndAnimation.duration = 1.4
        self.avatarButton?.layer.addAnimation(strokeStartAnimation, forKey:"rotationAnimation")

    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        setOffsetY(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
}










