//
//  FancyButtonView.swift
//  RAB
//
//  Created by visvavince on 3/14/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

public enum FancyButtonViewMode: String {
    case Single
    case TextWithImageOnRight
    case Unknown
}

open class FancyButtonView: UIView {
    
    // outlets
    @IBOutlet open weak var mainLabel: UILabel!
    @IBOutlet open weak var mainButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet open weak var sideButton: UIButton!
    // use to hide side view
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideViewLeading: NSLayoutConstraint!
    @IBOutlet open weak var rightImageView: UIImageView!
    @IBOutlet weak var rightImageHeight: NSLayoutConstraint!
    // class properties
    open var mode: FancyButtonViewMode = .Unknown
    
    override open func updateConstraints() {
        switch self.mode {
        case .Single:
            hideSideView(true)
        case .TextWithImageOnRight:
            hideSideView(false)
        default:
            break
        }
        super.updateConstraints()
    }
    
    // solved layout issues with swift 3, needed to set bounds here
    // for it to get the correct bounds
    //
    open override func layoutSubviews() {
        self.mainView.frame = bounds
    }
    
    fileprivate func hideSideView(_ hide: Bool) {
        if hide {
            rightImageView.isHidden = true
            sideView.isHidden = true
            sideViewLeading.constant = 0
            rightImageHeight.constant = 0
        } else {
            rightImageView.isHidden = false
            sideView.isHidden = false
            sideViewLeading.constant = 15
            rightImageHeight.constant = 25
        }
    }
    
    // Setup
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.dynamicTypeName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func nibSetup() {
        self.mainView = loadViewFromNib()
        self.mainView.frame = bounds
        self.mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mainView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(mainView)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        nibSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    open func setupUI(_ title: String, titleColor: UIColor,
        rightImageName: String) {
        self.mode = .TextWithImageOnRight
        self.isRoundCorners = true
        self.mainLabel.text = title
        self.mainLabel.textColor = titleColor
        rightImageView.image = UIImage(named: rightImageName)
    }

}
