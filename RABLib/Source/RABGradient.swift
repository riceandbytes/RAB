//
//  RABLayer.swift
//  RAB
//
//  Created by visvavince on 8/27/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

public class RABGradient {
    
    public class func BlueGradientMake(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        let colorOne = UIColor(red: 120.0/255, green: 135.0/255, blue: 150.0/255, alpha: 100.0)
        let colorTwo = UIColor(red: 57.0/255, green: 79.0/255, blue: 96.0/255, alpha: 100.0)
        let colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.colors = colors
        return layer
    }
    
    public class func RandomGradientMake(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        let colorOne = UIColor(red: 120.0/255, green: 135.0/255, blue: 150.0/255, alpha: 100.0)
        let colorTwo = UIColor(red: 57.0/255, green: 79.0/255, blue: 96.0/255, alpha: 100.0)
        let colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.colors = colors
        return layer
    }

    public class func RandomKidGradientMake(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        let diffR:CGFloat = 120 - 57
        let diffG:CGFloat = 135 - 79
        let diffB:CGFloat = 150 - 96
        
        let purple: [CGFloat] = [204,154,255]
        let blue: [CGFloat] = [0,189,210]
        let green: [CGFloat] = [183,233,104]
        let orange: [CGFloat] = [250,105,0]
        let yellow: [CGFloat] = [255,253,130]
        let color1: [CGFloat] = [48, 242, 187]
        let color2: [CGFloat] = [45, 208, 229]
        let color3: [CGFloat] = [242, 48, 103]
        let color4: [CGFloat] = [242, 48, 67]
        let color5: [CGFloat] = [242, 43, 179]
        
        let allColors: [[CGFloat]] = [purple, blue, green, orange, yellow, color1, color2, color3, color4, color5]

        let random = Int(arc4random_uniform(10))
        pln(random)
        
        let aColor = allColors[random]

        
        
        let colorOne = UIColor(red: aColor[0]/255,
                               green: aColor[1]/255,
                               blue: aColor[2]/255,
                               alpha: 100.0)
        let colorTwo = UIColor(red: (aColor[0] - diffR)/255,
                               green: (aColor[1] - diffG)/255,
                               blue: (aColor[2] - diffB)/255,
                               alpha: 100.0)
        let colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.colors = colors
        return layer
    }
}

@IBDesignable
public class RABGradientView: UIView {
    
    @IBInspectable public var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable public var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable public var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable public var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable public var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable public var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
