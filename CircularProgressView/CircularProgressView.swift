//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by Parker Rushton on 2/24/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

protocol ProgressViewObjectType {
    
    var total: Float { get }
    var progress: Float { get }
}

@IBDesignable class CircularProgressView: UIView {
    
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    @IBInspectable var trackTintColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var progressTintColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 20.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable private var total: Float = 0 {
        didSet {
            updateLabels()
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var progress: Float = 0 {
        didSet {
            updateLabels()
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    private var progressPercentage: CGFloat {
        return CGFloat(progress / total)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createLabels()
    }
    
    override func drawRect(rect: CGRect) {
        let width = CGRectGetWidth(bounds)
        let height = CGRectGetHeight(bounds)
        let radius = (min(width, height) - lineWidth) / 2
        let centerPoint = CGPoint(x: width/2, y: height/2)
        
        // Draw the full track
        fillTrack(center: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), color: trackTintColor)
        
        // Draw the progress track
        let endAngle = CGFloat(2 * M_PI * Double(progressPercentage) - (M_PI / 2))
        fillTrack(center: centerPoint, radius: radius, startAngle: CGFloat(-M_PI / 2), endAngle: endAngle, color: progressTintColor)
    }
    
    func update(progressObject: ProgressViewObjectType) {
        total = progressObject.total
        progress = progressObject.progress
    }
    
}

private extension CircularProgressView {
    
    func createLabels() {
        topLabel.backgroundColor = .blueColor()
        let stackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        addSubview(stackView)
        updateLabels()
        
        addConstraint(leadingAnchor.constraintEqualToAnchor(stackView.leadingAnchor))
        addConstraint(trailingAnchor.constraintEqualToAnchor(stackView.trailingAnchor))
        addConstraint(topAnchor.constraintEqualToAnchor(stackView.topAnchor))
        addConstraint(bottomAnchor.constraintEqualToAnchor(stackView.bottomAnchor))
    }
    
    func updateLabels() {
        topLabel.attributedText = weightRemainingLabelText()
        bottomLabel.text = "left to lose"
    }
    
    func weightRemainingLabelText() -> NSAttributedString {
        let poundsString = "\(total - progress)"
        let remainingString = poundsString + " lbs"
        let poundsRange = (remainingString as NSString).rangeOfString(poundsString)
        let attributedString = NSMutableAttributedString(string: remainingString, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(20.0)])
        attributedString.setAttributes([NSFontAttributeName: UIFont.systemFontOfSize(30.0, weight: 7)], range: poundsRange)
        
        return attributedString
    }
    
    func fillTrack(center center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        UIView.animateWithDuration(0.4) {
            path.stroke()
        }
    }
    
}
