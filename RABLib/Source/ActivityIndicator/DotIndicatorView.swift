//
//  RabDotActivityIndicator.swift
//  RAB
//
//  Created by RAB on 4/26/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import UIKit


@objc public protocol DotIndicatorViewDelegate
{
    func activityIndicatorView(_ activityIndicatorView: DotIndicatorView,
        circleBackgroundColorAtIndex index: NSInteger) -> UIColor
    
}

open class DotIndicatorView: UIView, CAAnimationDelegate {
    
    
    // MARK: - Private properties
    
    
    /// The number of circle indicators.
    fileprivate var _numberOfCircles            = 5
    
    /// The base animation delay of each circle.
    fileprivate var delay                       = 0.2
    
    /// The base animation duration of each circle
    fileprivate var duration                    = 0.8
    
    /// Total animation duration
    fileprivate var _animationDuration:Double   = 2
    
    /// The spacing between circles.
    fileprivate var _internalSpacing:CGFloat    = 5
    
    /// The maximum radius of each circle.
    fileprivate var _maxRadius:CGFloat          = 10
    
    // The minimum radius of each circle
    fileprivate let minRadius:CGFloat           = 2
    
    /// Default color of each circle
    fileprivate var _defaultColor                        = UIColor.lightGray
    
    /// An indicator whether the activity indicator view is animating or not.
    fileprivate var isAnimating         = false
    
    
    // MARK: - Public properties
    
    open var progressLabel: UILabel?
    open var progressLabelText: String = ""
    
    /// Delegate, used to chose the color of each circle.
    open weak var delegate: DotIndicatorViewDelegate?
    
    //MARK: - Public computed properties
    
    /// The number of circle indicators.
    open var numberOfCircles:Int {
        get {
            return _numberOfCircles
        }
        set {
            _numberOfCircles    = newValue
            delay               = 2*duration/Double(numberOfCircles)
            updateCircles()
        }
    }
    
    /// Default color of each circle
    open var defaultColor:UIColor {
        get  {
            return _defaultColor
        }
        set {
            _defaultColor    = newValue
            updateCircles()
        }
    }
    
    /// Total animation duration
    open var animationDuration:Double {
        get {
            return _animationDuration
        }
        set {
            _animationDuration  = newValue
            duration            = _animationDuration/2
            delay               = 2*duration/Double(numberOfCircles)
            updateCirclesanimations()
        }
        
    }
    
    /// The maximum radius of each circle.
    open var maxRadius:CGFloat {
        get {
            return _maxRadius
        }
        set {
            _maxRadius = newValue
            if _maxRadius < minRadius {
                _maxRadius = minRadius
            }
            updateCircles()
        }
    }
    
    /// The spacing between circles.
    open var internalSpacing:CGFloat {
        get {
            return _internalSpacing
        }
        set {
            _internalSpacing = newValue
            if (_internalSpacing * CGFloat(numberOfCircles-1) >  self.frame.width) {
                _internalSpacing = (self.frame.width - CGFloat(numberOfCircles) * minRadius) / CGFloat(numberOfCircles-1)
            }
            updateCircles()
        }
    }
    
    // MARK: - override
    
    public convenience init () {
        self.init(frame:CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
//    public override func translatesAutoresizingMaskIntoConstraints() -> Bool {
//        return false
//    }
    
    // MARK: - private methods
    
    // Sets up defaults values
    fileprivate func setupDefaults() {
        numberOfCircles         = 5
        internalSpacing         = 5
        maxRadius               = 10
        animationDuration       = 2
        defaultColor            = UIColor.lightGray
        
    }
    
    /// Creates the circle view.
    ///
    /// :param: radius The radius of the circle.
    /// :param: color The background color of the circle.
    /// :param: positionX The x-position of the circle in the contentView.
    /// :param: posX The x-position of the circle in the contentView.
    /// :param: posY The y-position of the circle in the contentView.
    ///
    /// :returns: The circle view
    fileprivate func createCircleWithRadius(_ radius:CGFloat, color:UIColor, posX:CGFloat, posY:CGFloat) -> UIView {
        let circle = UIView(frame: CGRect(x: posX, y: posY, width: radius*2, height: radius*2))
        circle.backgroundColor      = color
        circle.layer.cornerRadius   = radius
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }
    
    /// Creates the animation of the circle.
    ///
    /// :param: duration The duration of the animation.
    /// :param: delay The delay of the animation
    ///
    /// :returns: The animation of the circle.
    fileprivate func createAnimationWithDuration(_ duration:Double, delay:Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.delegate              = self
        animation.fromValue             = 0
        animation.toValue               = 1
        animation.autoreverses          = true
        animation.duration              = duration
        animation.isRemovedOnCompletion   = false
        animation.beginTime             = CACurrentMediaTime() + delay
        animation.repeatCount           = MAXFLOAT
        animation.timingFunction        = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    /// Add the circles
    fileprivate func addCircles () {
        var color = defaultColor
        
        var radiusForCircle  = (self.frame.width - CGFloat(numberOfCircles-1)*internalSpacing)/CGFloat(2*numberOfCircles)
        if radiusForCircle > self.frame.height/2 {
            radiusForCircle = self.frame.height/2
        }
        
        if radiusForCircle > maxRadius {
            radiusForCircle = maxRadius
        }
        
        var widthUsed = 2*radiusForCircle * CGFloat(numberOfCircles) + CGFloat(numberOfCircles-1)*internalSpacing
        if widthUsed > self.frame.width {
            widthUsed = self.frame.width
        }
        
        let offsetX = (self.frame.width - widthUsed)/2
        
        let posY = (self.frame.height - 2*radiusForCircle)/2
        
        for i in 0..<numberOfCircles {
            if let colorFromDelegate = delegate?.activityIndicatorView(self, circleBackgroundColorAtIndex: i) {
                color = colorFromDelegate
            } else {
                color = defaultColor
            }
            
            let posX = offsetX + CGFloat(i) * ((2*radiusForCircle) + internalSpacing)
            let circle = createCircleWithRadius(radiusForCircle, color: color, posX: posX, posY: posY)
            circle.transform = CGAffineTransform(scaleX: 0, y: 0)
            addSubview(circle)
        }
        updateCirclesanimations()
        
        // Add Label
        if progressLabel == nil {
            let font = UIFont(name: "GillSans", size: 18.0)!
            let sidePad: CGFloat = 20
            let frame  = CGRect(x: sidePad, y: posY + radiusForCircle*2, width: self.frame.width - sidePad*2, height: 80)
            progressLabel = UILabel(frame: frame)
            progressLabel!.textColor = UIColor.white
            progressLabel!.textAlignment = .center
            progressLabel!.font = font
            progressLabel!.text = progressLabelText
            progressLabel!.numberOfLines = 6

            addSubview(progressLabel!)
        }
    }
    
    
    // Update the animation for the circles
    fileprivate func updateCirclesanimations () {
        for i in 0..<subviews.count {
            let subview = subviews[i]
            subview.layer .removeAnimation(forKey: "scale")
            subview.layer.add(self.createAnimationWithDuration(duration, delay: Double(i)*delay), forKey: "scale")
        }
    }
    
    /// Remove the circles
    fileprivate func removeCircles () {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    // Update the circles when a property is changed
    fileprivate func updateCircles () {
        removeCircles()
        if isAnimating {
            addCircles()
        }
    }
    
    //MARK: - public methods
    
    open func startAnimating () {
        if !isAnimating {
            addCircles()
            isHidden = false
            isAnimating = true
        }
    }
    
    open func stopAnimating () {
        if isAnimating {
            removeCircles()
            isHidden = true
            self.isAnimating = false
        }
    }
}
