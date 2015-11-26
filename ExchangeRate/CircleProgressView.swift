//
//  CircleProgressView.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/10/30.
//  Copyright © 2015 AlexChen. All rights reserved.
//

import Foundation
import UIKit

@objc @IBDesignable public class CircleProgressView: UIView {

    internal struct Constants {
        let circleDegress = 360.0
        let minimumValue = 0.000001
        let maximumValue = 0.999999
        let ninetyDegrees = 90.0
        let twoSeventyDegrees = 270.0
        var contentView:UIView = UIView()
    }

    let constants = Constants()
    private var internalProgress:Double = 0.0

    @IBInspectable public var progress: Double = 0.000001 {
        didSet {
            if progress == 0 {
                internalProgress = constants.minimumValue
            } else if progress >= 1 {
                internalProgress = constants.maximumValue
            } else {
                internalProgress = progress
            }
            setNeedsDisplay()
        }
    }

    @IBInspectable public var clockwise: Bool = true {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackWidth: CGFloat = 2.4 {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackImage: UIImage? {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackBackgroundColor: UIColor = UIColor.clearColor() {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackFillColor: UIColor = UIColor.whiteColor() {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackBorderColor:UIColor = UIColor.clearColor() {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var trackBorderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var centerFillColor: UIColor = UIColor.blackColor() {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var contentView: UIView {
        return self.constants.contentView
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
    }

    required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
        self.addSubview(contentView)
    }

    override public func drawRect(rect: CGRect) {

        super.drawRect(rect)

        let innerRect = CGRectInset(rect, trackBorderWidth, trackBorderWidth)

        internalProgress = clockwise ?
            (-constants.twoSeventyDegrees + ((1.0 - internalProgress) * constants.circleDegress)) :
            (constants.ninetyDegrees - ((1.0 - internalProgress) * constants.circleDegress))

        let context = UIGraphicsGetCurrentContext()

        let centerPath = UIBezierPath(ovalInRect: CGRectMake(innerRect.minX + trackWidth, innerRect.minY + trackWidth, CGRectGetWidth(innerRect) - (2 * trackWidth), CGRectGetHeight(innerRect) - (2 * trackWidth)))

        // background Drawing
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(innerRect.minX, innerRect.minY, CGRectGetWidth(innerRect), CGRectGetHeight(innerRect)))

        circlePath.appendPath(centerPath)
        circlePath.usesEvenOddFillRule = true
        circlePath.addClip()

        trackBackgroundColor.setFill()
        circlePath.fill();

        if trackBorderWidth > 0 {
            circlePath.lineWidth = trackBorderWidth
            trackBorderColor.setStroke()
            circlePath.stroke()
        }

        // progress Drawing
        let progressPath = UIBezierPath()
        let progressRect: CGRect = CGRectMake(innerRect.minX, innerRect.minY, CGRectGetWidth(innerRect), CGRectGetHeight(innerRect))
        let center = CGPointMake(progressRect.midX, progressRect.midY)
        let radius = progressRect.width / 2.0
        let startAngle:CGFloat = clockwise ? CGFloat(-internalProgress * M_PI / 180.0) : CGFloat(constants.twoSeventyDegrees * M_PI / 180)
        let endAngle:CGFloat = clockwise ? CGFloat(constants.twoSeventyDegrees * M_PI / 180) : CGFloat(-internalProgress * M_PI / 180.0)

        progressPath.addArcWithCenter(center, radius:radius, startAngle:startAngle, endAngle:endAngle, clockwise:!clockwise)
        progressPath.addLineToPoint(CGPointMake(progressRect.midX, progressRect.midY))
        progressPath.closePath()

        CGContextSaveGState(context)

        progressPath.addClip()

        if trackImage != nil {
            trackImage!.drawInRect(innerRect)
        } else {
            trackFillColor.setFill()
            circlePath.fill()
        }

        CGContextRestoreGState(context)
    }
}