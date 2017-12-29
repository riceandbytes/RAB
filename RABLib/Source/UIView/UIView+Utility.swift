//
//  UIView+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public extension UIView {
    
    /**
     This function will print out all constraints for a
     UI object
     */
    public func printAllConstraints() {
        for con in self.constraints {
            pWarn(con.debugDescription)
        }
    }
    
    /**
     This adds a Done button above the keyboard
     
     */
    public func addDoneButton(_ backgroundColor: UIColor = .white) {
        let doneButtonFont = Const.makeFont(.Regular, 18)!
        
        // add done button
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.barStyle = UIBarStyle.default
        toolbar.backgroundColor = backgroundColor
        toolbar.sizeToFit()
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIView.closePickerView))
        let attr: Dictionary<NSAttributedStringKey, AnyObject> = [
            NSAttributedStringKey.foregroundColor: Const.GrayLight,
            NSAttributedStringKey.font: doneButtonFont
        ]
        doneButton.setTitleTextAttributes(attr, for: UIControlState())
        toolbar.items = [spacer, doneButton]
        toolbar.backgroundColor = backgroundColor
        
        
        if let field = self as? UITextField {
            field.inputAccessoryView = toolbar
        } else if let view = self as? UITextView {
            view.inputAccessoryView = toolbar
        } else {
            pErr("Cannot add a done toolbar to a view of type \(type(of: self))")
        }
    }
    
    @objc public func closePickerView() {
        self.endEditing(true)
        
        if let pickerView = self.inputView as? UIPickerView {
            if let delegate = pickerView.delegate, let dataSource = pickerView.dataSource {
                for component in 0...(dataSource.numberOfComponents(in: pickerView) - 1) {
                    let selectedRow = pickerView.selectedRow(inComponent: component)
                    delegate.pickerView!(pickerView , didSelectRow: selectedRow, inComponent: component)
                }
            }
        }
    }
    
    public func setupGradient() {
        let gradientLayerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/2))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.clear.cgColor]
        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        self.layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    public func turnIntoCircle() {
        doOnMain {
            self.layer.cornerRadius = self.bounds.size.width / 2
            self.layer.masksToBounds = true
        }
    }
    
    func addBadge(_ badge: Int,
                        font: UIFont,
                        bkgColor: UIColor,
                        offsetEdge: CGFloat = 0,
                        textColor: UIColor = .white,
                        makeCircle: Bool = true,
                        tag: Int? = nil) {
        
        // Find which view we can add to sometimes superview is not avail
        let parentView = self.superview ?? self
        
        var badgeText = String(badge)
        
        if badge > 99 {
            badgeText = "99+"
        } else if badge == 0 {
            removeBadge()
            return
        }
        
        var badgeTag = getBadgeTag()
        if let t = tag {
            badgeTag = t
        }
        
        // make a generic label and get the size for it; we'll create a frame later
        let label = (parentView.viewWithTag(badgeTag) as? UILabel) ?? UILabel()
        label.tag = badgeTag
        label.text = badgeText
        label.font = font
        label.textColor = UIColor.white
        label.backgroundColor = bkgColor
        label.isCircle = makeCircle
        label.textAlignment = .center
        label.sizeToFit()

        // get the values to use for creating the label's frame
        let width = label.frame.width
        let height = label.frame.height
        let charCount: CGFloat = CGFloat(badgeText.count)
        let widthPerChar = width / charCount
        
        // for each additional character, the label grows
        // we want to move it to the left as we add more chars
        let offsetFromRightEdge = ((charCount - 1) * widthPerChar / 2 )
        
        let x: CGFloat = self.frame.origin.x + self.frame.width - offsetFromRightEdge - offsetEdge
        let y: CGFloat = self.frame.origin.y - 10 + offsetEdge
        
        if makeCircle {
            let border: CGFloat = 5
            var w: CGFloat = width
            if height > width {
                w = height
            }
            w += border
            label.frame = CGRect(x: x, y: y, width: w, height: w)
        } else {
            label.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    
        parentView.addSubview(label)
    }
    
    func removeBadge(tag: Int? = nil) {
        var badgeTag = getBadgeTag()
        if let t = tag {
            badgeTag = t
        }

        // Find which view we can add to sometimes superview is not avail
        let parentView = self.superview ?? self

        if let badgeView = parentView.viewWithTag(badgeTag) as? UILabel {
            badgeView.removeFromSuperview()
        }
    }
    
    /**
     When we rotate screen we need to recalc
     */
//    func updateBadgeFrame(makeCircle: Bool = true,
//                          offsetEdge: CGFloat = 0)
//    {
//        let parentView = self.superview ?? self
//
//        if let badgeView = parentView.viewWithTag(getBadgeTag()) as? UILabel {
//            let badgeText = badgeView.text ?? ""
//            let width = badgeView.frame.width
//            let height = badgeView.frame.height
//            let charCount: CGFloat = CGFloat(badgeText.characters.count)
//            let widthPerChar = width / charCount
//
//            // for each additional character, the label grows
//            // we want to move it to the left as we add more chars
//            let offsetFromRightEdge = ((charCount - 1) * widthPerChar / 2 )
//
//            let x: CGFloat = parentView.frame.origin.x + parentView.frame.width - offsetFromRightEdge - offsetEdge
//            let y: CGFloat = parentView.frame.origin.y - 10 + offsetEdge
//
//            if makeCircle {
//                let border: CGFloat = 5
//                var w: CGFloat = width
//                if height > width {
//                    w = height
//                }
//                w += border
//                badgeView.frame = CGRect(x: x, y: y, width: w, height: w)
//            } else {
//                badgeView.frame = CGRect(x: x, y: y, width: width, height: height)
//            }
//        }
//    }
    
    fileprivate func getBadgeTag() -> Int {
        // tag this label with the x/y of the view it's for so we can find it later
        return Int(self.frame.origin.x * self.frame.origin.y)
    }
    
    @IBInspectable public var isCircle: Bool {
        set {
            if newValue {
                turnIntoCircle()
            }
        }
        get {
            return (self.layer.cornerRadius == (self.bounds.size.width / 2)) && self.layer.masksToBounds
        }
    }

    @IBInspectable public var isRoundCorners: Bool {
        set {
            if newValue {
                doRoundCorners()
            }
        }
        get {
            return (self.layer.cornerRadius == self.frame.size.height/2) && self.layer.masksToBounds
        }
    }
    
    fileprivate func doRoundCorners() {
        doOnMain {
            self.layer.cornerRadius = self.frame.size.height/2
            self.layer.masksToBounds = true
        }
    }

    // MARK: - Image
    
    // Convert from UIView to UIImage
    // Use to mail message
    // ex:     NSData *data = UIImageJPEGRepresentation(UIImageToSend,1);
    // mail ex:         mailComposeVC.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "emailImage")!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
    //
    public func takeSnapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if self.superview == nil {
            // it's not drawn, we have to use renderInContext
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
        } else {
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     Used to clear all subviews
     */
    public func removeAllSubviews() {
        for subview in self.subviews as [UIView] {
            subview.removeFromSuperview()
        }
    }
    
    public class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    /// Locate the constraint dictating this view's height, if any
    func findHeightConstraint() -> NSLayoutConstraint? {
        for c in constraints {
            if c.firstAttribute == NSLayoutAttribute.height {
                if let first = c.firstItem as? NSObject {
                    if first == self {
                        return c
                    }
                }
            }
        }
        return nil
    }
}

// MARK: - Add Activity

// Usage:
// - start animation
// tableView.activityIndicatorView.startAnimating()
//
// - stop animation
// tableView.activityIndicatorView.stopAnimating()
// http://stackoverflow.com/questions/29912852/how-to-show-activity-indicator-while-tableview-loads
//
fileprivate var kActivityIndicatorViewAssociativeKey = "kActivityIndicatorViewAssociativeKey"
public extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            guard let activityIndicatorView = getAssociatedObject(&kActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView else {
                
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                activityIndicatorView.activityIndicatorViewStyle = .gray
                activityIndicatorView.color = .gray
                activityIndicatorView.center = center
                activityIndicatorView.frame.y = activityIndicatorView.frame.y - 40
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &kActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
            return activityIndicatorView
        }
        
        set {
            addSubview(newValue)
            setAssociatedObject(newValue, associativeKey:&kActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setupActivityIndicator(style: UIActivityIndicatorViewStyle, color: UIColor) {
        activityIndicatorView.activityIndicatorViewStyle = style
        activityIndicatorView.color = color
    }
}

// MARK: - Add Animations

extension UIView {
    
    public func isHideAnimate(hide: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options:
            UIViewAnimationOptions.curveEaseOut, animations: {
                if (hide) {
                    self.alpha = 0
                } else {
                    self.alpha = 0
                    self.isHidden = false // We need this to see the animation 0 -> 1
                    self.alpha = 1
                }
            }, completion: { finished in
                self.isHidden = hide
        })
    }
    
    /// Use this to show a view that load from bottom up
    /// - vc.view.addAnimateShowFromBottomUp()
    ///
    public func addAnimateShowFromBottomUp() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.layer.add(transition, forKey: kCATransition)
    }
}


// MARK: - Add Gradient

extension UIView {
    
    public func addGradient_topDown_whiteToDark(_ gradientLayer: CAGradientLayer) {
//            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            let color1 = UIColor.clear.cgColor as CGColor
            let color2 = UIColor(white: 0.0, alpha: 0.5).cgColor as CGColor
            gradientLayer.colors = [color1, color2]
            gradientLayer.locations = [0.0, 0.6]
            self.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Add Blured Overlay to View

extension UIView {
    // http://stackoverflow.com/questions/17041669/creating-a-blurring-overlay-view
    //
    // Havent Tested
    //
    func addBlurOverlay() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else {
            self.backgroundColor = UIColor.black
        }
    }
}

// MARK: - Used to check if the view is Visible
extension UIView {
    public func isVisible() -> Bool {
        func isVisible(_ view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view, inView: inView.superview)
            }
            return false
        }
        return isVisible(self, inView: self.superview)
    }
}

extension UIView {
    
    // ex:             commentView.addConstraintsWithFormat("V:|[v0]|", views: bubbleImageView)
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}
