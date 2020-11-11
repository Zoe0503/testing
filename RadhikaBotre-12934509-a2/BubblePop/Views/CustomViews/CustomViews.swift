//
//  RoundBubbleButton.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

///This class is used to represent a bubble and it's current moving speed
class RoundBubbleButton: UIButton {
    
    ///Instance variables
    var bubble: RoundBubble?
    var bubbleMovingSpeed: CGPoint = CGPoint(x: -1.0, y: -1.0)
}

///This class is used to represent  a bubble image 
class RoundBubbleImage: UIImage {
    
    ///Instance variables
    var bubble: RoundBubble?
    var bubbleMovingSpeed: CGPoint = CGPoint(x: -1.0, y: -1.0)
}
