//
//  DesignView.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignView: UITableViewCell{
    
    @IBInspectable var cornerradius : CGFloat = 4
    
    @IBInspectable var shadowOffsetWidth : Int = 0
    
    @IBInspectable var shadowOffsetHeigth : Int = 5
    
    @IBInspectable var shadowColor : UIColor? = UIColor.black
    
    @IBInspectable var shadowOpacity : Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeigth)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }  
}
