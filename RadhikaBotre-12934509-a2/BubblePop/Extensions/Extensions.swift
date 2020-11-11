//
//  Extensions.swift
//  BubblePop
//
//  Created by Radhika on 01/05/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

@IBDesignable class RoundView: UIView {}
@IBDesignable class RoundButton: UIButton {}

///This is to provide additional properties and methods to UIView class
extension UIView {
    
    ///IBdesignable property cornerRadiusValue to change the corner radius of any UIView
    @IBInspectable
    var cornerRadiusValue: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    ///IBdesignable property borderColor to change the border color of any UIView
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    ///IBdesignable property borderWidth to change the border width of any UIView
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

///CustomSlider class to add IBdesignable property trackWidth so that the track with of slider can be changed
open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    ///Customising the drawing rectangle of the slider
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
