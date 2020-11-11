//
//  Positioner.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation
import UIKit

class Positioner {
    
    ///Random arrays are generated of where the bubbles must be positioned
    static func getAccessiblePosition(layout: GameLayout, totalCount: Int, exceptivePositions: [CGPoint]) -> [CGPoint] {
        
        var positions: [CGPoint] = []
        
        let randomXs: [Int] = RandomGenerator.randomInt(end: layout.horizontalBubbles)
        let randomYs: [Int] = RandomGenerator.randomInt(end: layout.verticalBubbles)
        
        for i in 0...totalCount {
            
            let x = CGFloat(Float(randomXs[i%layout.horizontalBubbles]) * layout.bubbleDiameter + layout.leftMargin)
            let y = CGFloat(Float(randomYs[i%layout.verticalBubbles]) * layout.bubbleDiameter + layout.topMargin)
            
            var accessible = true
            for item in exceptivePositions {
                if abs(item.x - x) < CGFloat(layout.bubbleDiameter) && abs(item.y - y) < CGFloat(layout.bubbleDiameter) {
                    accessible = false
                }
            }
            if accessible {
                let position: CGPoint = CGPoint(x: x, y: y)
                positions.append(position)
            }
        }
        return positions
    }
}


