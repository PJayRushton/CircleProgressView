//
//  Goal.swift
//  welbe
//
//  Created by Parker Rushton on 2/8/16.
//  Copyright © 2016 OC Tanner Company. All rights reserved.
//

import Foundation

enum GoalType: String {
    case Weight = "weight-loss-goals"
    case Stress = "stress"
    case Activity = "activity"
    
    var targetType: String {
        switch self {
        case .Weight:
            return "targetWeight"
        case .Stress, .Activity:
            return ""
        }
    }
}

struct WeighIn {
    
    let weight: Int
    let date: NSDate
    
    init(weight: Int, date: NSDate = NSDate()) {
        self.weight = weight
        self.date = date
    }
    
}

struct Goal: ProgressViewObjectType {
    
    let type: GoalType
    let title: String
    let description: String
    let comingSoonString: String?
    let startDate: NSDate
    var target: Int
    var weighIns: [WeighIn] = [WeighIn]()
    
    var total: Float {
        return Float(targetLoss!)
    }
    
    var progress: Float {
        return Float(currentLoss!)
    }
    
    // MARK: Computed vars
    
    var startingWeight: Int? {
        return weighIns.first?.weight
    }
    var currentWeight: Int? {
        return weighIns.last?.weight
    }
    var targetLoss: Int? {
        guard let firstWeighIn = weighIns.first else { return nil }
        return firstWeighIn.weight - target
    }
    var currentLoss: Int? {
        guard let startingWeight = startingWeight, currentWeight = currentWeight else { return nil }
        return startingWeight - currentWeight
    }
    
    init(type: GoalType, target: Int = 0) {
        self.type = type
        startDate = NSDate()
        self.target = target
        description = "Welbe helps you track meals and activity while providing expert guidance so you can achieve your goal"
        let defaultComingSoonString = "We're in the process of building this type of wellness goal. \nGet ready, it's going to be great!"
        switch type {
        case .Weight:
            title = "Lose weight"
            comingSoonString = nil
        case .Stress:
            title = "Reduce stress"
            comingSoonString = defaultComingSoonString
        case .Activity:
            title = "Be more active"
            comingSoonString = defaultComingSoonString
        }
    }
    
    mutating func updateTarget(newTarget target: Int) {
        self.target = target
    }
}
