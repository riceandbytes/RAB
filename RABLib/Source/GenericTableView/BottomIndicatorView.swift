//
//  BottomIndicatorView.swift
//  RAB
//
//  Created by visvavince on 7/22/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation
/**
 Usage:
 self.tableFooterView = SWBottomIndicatorView(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), 60))
 */
open class BottomIndicatorView: UIView {
    // properties
    var indicatorFooter: UIActivityIndicatorView!
    var infoLabel: UILabel!
    
    // init
    override init (frame : CGRect) {
        super.init(frame : frame)
        pAssert(frame.size.height > 40, "Height of frame must be greater than 40 to fit image")
        setup()
        showInfoLabel(false)
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    // config
    fileprivate func setup() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ships")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(imageView)
        topView.backgroundColor = UIColor.clear
        indicatorFooter = UIActivityIndicatorView()
        self.addSubview(topView)
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(indicatorFooter)
        infoLabel = setupInfoLabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(infoLabel)
        self.addSubview(bottomView)
        
        let viewsDict = ["topView": topView,
                         "imageView": imageView,
                         "indicatorFooter": indicatorFooter,
                         "bottomView": bottomView,
                         "infoLabel": infoLabel]
        
        let imageViewConstraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView(35)]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
        let imageViewConstraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(35)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDict)
        topView.addConstraints(imageViewConstraintH)
        topView.addConstraints(imageViewConstraintV)
        imageView.centerInSuperview()
        
        let indi_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[indicatorFooter]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
        let indi_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[indicatorFooter]-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDict)
        bottomView.addConstraints(indi_H)
        bottomView.addConstraints(indi_V)
        
        let info_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[infoLabel]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
        let info_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[infoLabel(18)]-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDict)
        bottomView.addConstraints(info_H)
        bottomView.addConstraints(info_V)
        
        let topView_ConstraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[topView]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
        self.addConstraints(topView_ConstraintH)
        let indicatorFooter_ConstraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bottomView]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
        self.addConstraints(indicatorFooter_ConstraintH)
        let all_ConstraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[topView(35)]-0-[bottomView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsDict)
        self.addConstraints(all_ConstraintV)
        
        indicatorFooter.translatesAutoresizingMaskIntoConstraints = false
        
        indicatorFooter.backgroundColor = UIColor.clear
        indicatorFooter.color = UIColor.gray
    }
    
    fileprivate func setupInfoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .center
//        label.font = 
        label.text = "Aww Ship! Please Try Again."
        return label
    }
    
    // MARK: - Public Methods
    
    open func showInfoLabel(_ show: Bool) {
        if show {
            infoLabel.isHidden = false
            indicatorFooter.isHidden = true
        } else {
            infoLabel.isHidden = true
            indicatorFooter.isHidden = false
        }
    }
    
    open func startAnimating() {
        if indicatorFooter.isAnimating == false {
            indicatorFooter.startAnimating()
        }
    }
    
    open func stopAnimating() {
        pln()
        if indicatorFooter.isAnimating {
            pln()
            indicatorFooter.stopAnimating()
            pln()
            
        }
        pln()
        
    }
}
