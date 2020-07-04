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
    @IBOutlet open weak var highlightLeft: UIView!
    @IBOutlet open weak var highlightRight: UIView!

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
        font: UIFont, isRightSelected: Bool) {
            
        let highlightColor = UIColor(hex: "#5CABE5")
        let gray = UIColor(hex: "#536F8A")
        let clear = UIColor.clear

        self.leftButton.setTitleColor(gray, for: UIControl.State())
        self.rightButton.setTitleColor(gray, for: UIControl.State())
        highlightLeft.backgroundColor = clear
        highlightRight.backgroundColor = clear

        var leftTitleColor = gray
        var rightTitleColor = gray

        if isRightSelected {
            isRightEnabled = true
            rightTitleColor = highlightColor
            highlightRight.backgroundColor = highlightColor
        } else {
            isRightEnabled = false
            leftTitleColor = highlightColor
            highlightLeft.backgroundColor = highlightColor
        }
            
        self.leftButton.setTitle(leftTitle.uppercased(), for: UIControl.State())
        self.leftButton.titleLabel!.font = font
        self.leftButton.bkgColor = clear
        self.leftButton.strokeColor = clear
        self.leftButton.setTitleColor(leftTitleColor, for: UIControl.State())
        
        self.rightButton.setTitle(rightTitle.uppercased(), for: UIControl.State())
        self.rightButton.titleLabel?.font = font
        self.rightButton.bkgColor = clear
        self.rightButton.strokeColor = clear
        self.rightButton.setTitleColor(rightTitleColor, for: UIControl.State())
    }
}
