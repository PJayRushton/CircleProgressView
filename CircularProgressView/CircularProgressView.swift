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
    
    // MARK: - Constants

    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    
    // MARK: - IBInspectables
    
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
    @IBInspectable private var total: CGFloat = 0 {
        didSet {
            updateLabels()
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var progress: CGFloat = 0 {
        didSet {
            updateLabels()
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    private var progressPercentage: CGFloat {
        return progress / total
    }
    
    
    // MARK: - Overrides
    
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
    
    
    // MARK: - Public funcs
    
    func update(progressObject: ProgressViewObjectType) {
        total = CGFloat(progressObject.total)
        progress = CGFloat(progressObject.progress)
    }
    
}

private extension CircularProgressView {
    
    func createLabels() {
        let stackView = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
        updateLabels()
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        stackView.alignment = .Center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        addConstraint(leadingAnchor.constraintEqualToAnchor(stackView.leadingAnchor))
        addConstraint(trailingAnchor.constraintEqualToAnchor(stackView.trailingAnchor))
        addConstraint(centerYAnchor.constraintEqualToAnchor(stackView.centerYAnchor))
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
        path.stroke()
    }
    
}
