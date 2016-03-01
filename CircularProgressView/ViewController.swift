//
//  ViewController.swift
//  CircularProgressView
//
//  Created by Parker Rushton on 2/24/16.
//  Copyright © 2016 AppsByPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
    
    var goal = Goal(type: .Weight, target: 140)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goal.weighIns = [WeighIn(weight: 150), WeighIn(weight: 148), WeighIn(weight: 143)]
        progressSlider.maximumValue = Float(goal.targetLoss!)
        progressSlider.setValue(goal.progress, animated: false)
        widthSlider.maximumValue = Float(circularProgressView.frame.size.width / 2)
        widthSlider.setValue(Float(circularProgressView.lineWidth), animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        circularProgressView.update(goal)
    }
    
    @IBAction func progressSliderValueChanged(sender: UISlider) {
        let intSliderValue = Int(sender.value)
        sender.setValue(Float(intSliderValue), animated: true)
        goal.weighIns[2] = (WeighIn(weight: goal.weighIns.first!.weight - intSliderValue))
        circularProgressView.update(goal)
    }

    @IBAction func widthSliderValueChanged(sender: UISlider) {
        circularProgressView.lineWidth = CGFloat(sender.value)
    }
    
}
