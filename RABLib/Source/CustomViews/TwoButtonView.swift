//
//  TwoButtonView.swift
//  RAB
//
//  Created by RAB on 2/18/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//
/**
    Example:
    In the Viewcontroller that you use it in

    override func viewDidLoad() {
        let tbView = TwoButtonView(frame: CGRectMake(0, 0, 200, 30))
        tbView.configure("Blah", rightTitle: "Hello",
            font: SMFont.Bold12, cornerRadius: 50.0,
            bkgColor: Color_MainNav, strokeColor: UIColor.white, lineWidth: 1.0)
        
        tbView.leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        tbView.rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.navigationItem.titleView = tbView
    }

    func leftButtonAction(sender: UIButton!) {
        pln("Touched Left")
    }

    func rightButtonAction(sender: UIButton!) {
        pln("Touched Right")
    }
*/

import Foundation


open class TwoButtonView: UIView {
    @IBOutlet open weak var leftButton: GenRoundRectButton!
    @IBOutlet open weak var rightButton: GenRoundRectButton!
    
    @IBOutlet var myView: UIView!
    
    /// This lets you know which side is selected, right or left
    open var isRightEnabled = false
    
    // http://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if myView == nil {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: self.dynamicTypeName, bundle: bundle)
            self.myView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.myView.frame = bounds
            self.myView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        }
        
        // adding the top level view to the view hierarchy
        self.addSubview(myView)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        if myView == nil {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: self.dynamicTypeName, bundle: bundle)
            self.myView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            self.myView.translatesAutoresizingMaskIntoConstraints = true
            self.myView.frame = bounds
            self.myView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        }
        self.addSubview(myView)
    }
    
    open func configure(_ leftTitle: String, rightTitle: String,
        font: UIFont, cornerRadius: CGFloat, bkgColor: UIColor,
        strokeColor: UIColor, lineWidth: Float, isRightSelected: Bool) {
            
        var leftStrokeColor  = UIColor.clear
        var rightStrokeColor = UIColor.clear

        var leftTitleColor   = UIColor(hex: "#FFFFFF", alpha: 60)
        var rightTitleColor  = UIColor(hex: "#FFFFFF", alpha: 60)

        if isRightSelected {
            isRightEnabled = true
            rightStrokeColor = strokeColor
            rightTitleColor = strokeColor
        } else {
            isRightEnabled = false
            leftStrokeColor = strokeColor
            leftTitleColor = strokeColor
        }
            
        self.leftButton.setTitle(leftTitle, for: UIControl.State())
        self.leftButton.titleLabel!.font = font
        self.leftButton.cornerRadius = cornerRadius
        self.leftButton.bkgColor = bkgColor
        self.leftButton.strokeColor = leftStrokeColor
        self.leftButton.lineWidth = lineWidth
        self.leftButton.setTitleColor(leftTitleColor, for: UIControl.State())
        
        self.rightButton.setTitle(rightTitle, for: UIControl.State())
        self.rightButton.titleLabel?.font = font
        self.rightButton.cornerRadius = cornerRadius
        self.rightButton.bkgColor = bkgColor
        self.rightButton.strokeColor = rightStrokeColor
        self.rightButton.lineWidth = lineWidth
        self.rightButton.setTitleColor(rightTitleColor, for: UIControl.State())

    }
}
