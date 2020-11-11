//
//  RoundBubble.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

class RoundBubble {
    
    ///Instance variables
    ///Color - saves the colour of the random bubbles
    ///Points - all points get stored once the bubble has been tapped/popped
    let points: Int
    var color: UIColor
    
    ///Default initialiser
    init(color: UIColor, points: Int) {
        self.color = color
        self.points = points
    }
    
    ///This function generates random bubbles
    ///This function enables to generate bubbles randomly referring to the probability of the colors 
    static func generateRandomBubble() -> RoundBubble {
        let bubbleColor = Utils.generateColorForBubble()
        let points = BubblePoints.points(color: bubbleColor)
        return RoundBubble(color: bubbleColor, points: points)
    }
}
