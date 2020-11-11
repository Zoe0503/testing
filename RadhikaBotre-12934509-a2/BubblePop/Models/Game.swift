//
//  GameSettings.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation
import UIKit

struct GameSettings {
    
    ///Local structure variables
    ///Setting play time of game to 60 seconds as default
    var defaultPlayTime: TimeInterval = 60
    ///Maximum bubbles set to 15 bubbles as default
    var maxBubbles: Int = 15
    
    ///This represents the current moving speed
    var bubbleMovingSpeed: CGPoint = CGPoint(x: -1.0, y: -1.0)
}

///This represents the layout of the game
struct GameLayout {
    var topMargin: Float = 0
    var leftMargin: Float = 0
    var horizontalBubbles: Int = 0
    var verticalBubbles: Int = 0
    var bubbleDiameter: Float = 50
}
