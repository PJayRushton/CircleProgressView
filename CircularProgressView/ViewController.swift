//
//  ViewController.swift
//  CircularProgressView
//
//  Created by Parker Rushton on 2/24/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circleProgressView: CircleProgressView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
    
    let total = 10.0
    var current = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressSlider.maximumValue = Float(total)
        progressSlider.setValue(Float(current), animated: false)
        widthSlider.maximumValue = Float(circleProgressView.frame.size.width / 2)
        widthSlider.setValue(Float(circleProgressView.lineWidth), animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        circleProgressView.update(total, current: current)
    }
    
    @IBAction func progressSliderValueChanged(sender: UISlider) {
        let intSliderValue = Int(sender.value)
        sender.setValue(Float(intSliderValue), animated: true)
        current = Double(intSliderValue)
        circleProgressView.update(total, current: current)
    }

    @IBAction func widthSliderValueChanged(sender: UISlider) {
        circleProgressView.lineWidth = CGFloat(sender.value)
    }
    
}
