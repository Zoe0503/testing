//
//  BubblePoints.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation
import UIKit

///This enum is used to store points for different types of bubbles
enum BubblePoints: Int {
    case redBubble = 1
    case magentaBubble = 2
    case greenBubble = 5
    case blueBubble = 8
    case blackBubble = 10
    
    ///This returns all of the bubble points in an array 
    static func allValues() -> [BubbleImager] {
        return [.redBubble, .magentaBubble, .greenBubble, .blueBubble, .blackBubble]
    }
    ///Gain points depending on the color of the bubble
    static func points(color: UIColor) -> Int {
        switch color {
        case .red:
            return self.redBubble.rawValue
        case .magenta:
            return self.magentaBubble.rawValue
        case .green:
            return self.greenBubble.rawValue
        case .blue:
            return self.blueBubble.rawValue
        case .black:
            return self.blackBubble.rawValue
        default:
            return 0
        }
    }
}

///This enum is used to represent all of the possible directions the bubble could go
enum BubbleDirection: String {
    case rightDirection = "0"
    case leftDirection = "1"
    case upDirection = "2"
    case downDirection = "3"
    case upRightDirection = "4"
    case upLeftDirection = "5"
    case downRightDirection = "6"
    case downLeftDirection = "7"
    
    static func allValues() -> [BubbleDirection] {
        return [.rightDirection, .leftDirection, .upDirection, .downDirection, .upRightDirection, .upLeftDirection, .downRightDirection, .downLeftDirection]
    }
    
    ///Retrieves random directions relating to the identifier of its direction
    static func randomDirection(with id: Int) -> CGPoint {
        return Utils.getRandomDirection(with: id)
    }
}
