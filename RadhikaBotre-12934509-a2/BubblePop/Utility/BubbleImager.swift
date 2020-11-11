//
//  BubbleImager.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation
import UIKit

///Enum representing each colored bubble
enum BubbleImager:  String {
    //This represents an image associated with a bubble color
    case redBubble = "red_bubble.png"
    case magentaBubble = "magenta_bubble.png"
    case greenBubble = "green_bubble.png"
    case blueBubble = "blue_bubble.png"
    case blackBubble = "black_bubble.png"
    
    ///Returns all defined colored bubbles
    static func allValues() -> [BubbleImager] {
        return [.redBubble, .magentaBubble, .greenBubble, .blueBubble, .blackBubble]
    }
    
    ///This returns the image path corresponding to a color bubble
    static func pathOfImage(color: UIColor) -> String {
        switch color {
        case .magenta:
            return self.magentaBubble.rawValue
        case .red:
            return self.redBubble.rawValue
        case .green:
            return self.greenBubble.rawValue
        case .black:
            return self.blackBubble.rawValue
        case .blue:
            return self.blueBubble.rawValue
        default:
            return ""
        }
    }
}
