//
//  Utils.swift
//  BubblePop
//
//  Created by Radhika on 18/05/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit
import GameKit
import Foundation

///This class is for utility methods
class Utils{
    
    //Name validation
    static func isValidName(name: String?) -> Bool{
        if name == nil {return false}
        if name?.count == 0 {return false}
        let nameRegEx = "^[a-zA-Z\\s\\-'.]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: name!)
    }
    
   
    ///Random direction is retrieved based on the identifier of the direction
    static func getRandomDirection(with id: Int) -> CGPoint {
        switch id {
        case 0:
            return CGPoint(x: 1.0, y: 0)
        case 1:
            return CGPoint(x: -1.0, y: 0)
        case 2:
            return CGPoint(x: 0, y: -1.0)
        case 3:
            return CGPoint(x: 0, y: 1.0)
        case 4:
            return CGPoint(x: 1.0, y: -1.0)
        case 5:
            return CGPoint(x: -1.0, y: -1.0)
        case 6:
            return CGPoint(x: 1.0, y: 1.0)
        case 7:
            return CGPoint(x: -1.0, y: 1.0)
        default:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
    
    /// This is used to generate random bubble colors based upon the specified probability of appearance
     static func generateColorForBubble() -> UIColor {
         let source: GKRandomSource = GKARC4RandomSource()
         var container: Array<UIColor> = []
         // Red - 40%
         for _ in 1...40 {
             container.append(.red)
         }
        //Pink (aka Magenta) - 30%
         for _ in 1...30 {
             container.append(.magenta)
         }
        //Green - 15%
         for _ in 1...15 {
             container.append(.green)
         }
        //Blue - 10%
         for _ in 1...10 {
             container.append(.blue)
         }
        //Black - 5%
         for _ in 1...5 {
             container.append(.black)
         }
         let number: Int = source.nextInt(upperBound: container.count)
         return container[number]
     }
}
