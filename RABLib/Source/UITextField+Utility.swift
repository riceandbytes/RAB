//
//  UITextField+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

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
