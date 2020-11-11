//
//  Bubbles.swift
//  13634959-Eric_Gernan-Assignment_2_BubblePop
//
//  Created by Eric Gernan on 9/5/20.
//  Copyright © 2020 Eric Gernan. All rights reserved.
//

import UIKit

class Bubbles: UIButton {
    
    var value:Double = 0
    var radius:Int = 100
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = CGFloat(radius)
    
        let possibility = Int.random(in: 0...100)
        switch possibility {
        case 0...39:
            self.backgroundColor = UIColor.red
            self.value = 1
        case 39...69:
            self.backgroundColor = UIColor(hue: 0.8306, saturation: 1, brightness: 0.98, alpha: 1.0)
            self.value = 2
        case 70...84:
            self.backgroundColor = UIColor.green
            self.value = 5
        case 85...94:
            self.backgroundColor = UIColor.blue
            self.value = 8
        case 95...99:
            self.backgroundColor = UIColor.black
            self.value = 10
        default: print("error")
        }
    
    }
    
    func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.8
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 5.0
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func pulsate2() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.8
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 10.0
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func pulsate3() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.8
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 15.0
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    
    
    
}
