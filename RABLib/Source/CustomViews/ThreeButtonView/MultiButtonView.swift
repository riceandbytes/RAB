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

public enum MultiButtonViewType: Int {
    case one = 0
    case two
    case three
}

public class MultiButtonView: UIView {
    
    @IBOutlet open weak var button1: GenRoundRectButton!
    @IBOutlet open weak var button2: GenRoundRectButton!
    @IBOutlet open weak var button3: GenRoundRectButton!
    
    @IBOutlet open weak var highlight1: UIView!
    @IBOutlet open weak var highlight2: UIView!
    @IBOutlet open weak var highlight3: UIView!

    @IBOutlet var myView: UIView!
    
    /// This lets you know which side is selected, right or left
    public var selectedIndex: MultiButtonViewType = .one
    
    // http://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if myView == nil {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: self.dynamicTypeName, bundle: bundle)
            self.myView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
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
            self.myView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
            self.myView.translatesAutoresizingMaskIntoConstraints = true
            self.myView.frame = bounds
            self.myView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        }
        self.addSubview(myView)
    }
    
    public func configure(_ leftTitle: String,
                        middleTitle: String,
                        rightTitle: String,
                        font: UIFont,
                        selectIndex: MultiButtonViewType) {

        reset(button1, highlight1, font, leftTitle)
        reset(button2, highlight2, font, middleTitle)
        reset(button3, highlight3, font, rightTitle)

        switch selectIndex {
        case .one:
            highlight(button1, highlight1, font, leftTitle)
        case .two:
            highlight(button2, highlight2, font, middleTitle)
        case .three:
            highlight(button3, highlight3, font, rightTitle)
        }
        
        self.selectedIndex = selectIndex
    }
    
    private func highlight(_ button: GenRoundRectButton, _ myView: UIView, _ font: UIFont, _ title: String) {
        let clear = UIColor.clear
        button.setTitle(title.uppercased(), for: UIControl.State())
        button.titleLabel!.font = font
        button.bkgColor = clear
        button.strokeColor = clear
        
        let highlightColor = UIColor(hex: "#5CABE5")
        button.setTitleColor(highlightColor, for: UIControl.State())
        myView.backgroundColor = highlightColor
    }
    
    private func reset(_ button: GenRoundRectButton, _ myView: UIView, _ font: UIFont, _ title: String) {
        let gray = UIColor(hex: "#536F8A")
        let clear = UIColor.clear
        button.setTitleColor(gray, for: UIControl.State())
        myView.backgroundColor = clear
        button.setTitle(title.uppercased(), for: UIControl.State())
        button.titleLabel!.font = font
        button.bkgColor = clear
        button.strokeColor = clear
    }
}
