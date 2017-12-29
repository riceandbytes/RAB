//
//  UITextField+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    /// Assign a UIPickerView to be the input field for a UITextField
    ///
    /// :pickerView: the picker view
    /// :showDoneButton: Should a tool bar be added to display a Done button that closes the picker
    public func setPickerView(_ pickerView: UIPickerView,
                              showDoneButton: Bool = false,
                              backgroundColor: UIColor = .white)
    {
        pickerView.backgroundColor = backgroundColor
        self.inputView = pickerView
        
        if showDoneButton {
            addDoneButton(backgroundColor)
        }
    }
}

extension UITextField {
    
    /// Usage: yourtextFieldName.useUnderline()
    ///
    public func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

// MARK: - Add a bottom border

extension UITextField {

    func setBottomBorder(borderColor: UIColor = .white) {
        self.borderStyle = .none
        self.layer.backgroundColor = borderColor.cgColor
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = borderColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

// MARK: - Add Max Length to UITextField

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable public var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) { return self }
        return String( Array(self).prefix(upTo: n) )
    }
}
