//
//  UIPickerView+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public extension UIPickerView {
    /// Add a label to a component
    ///
    /// :label: the label string
    /// :leftSide: add to the left side of the label (default false)
    /// :forComponent: the component this label is meant for
    /// :offsetFromLabel: how far from the label (default 2)
    /// :fontSize: the font size of the label (default 20)
    /// :fontStyle: the font style (default Light)
    ///
    /// returns the UIView added to the view as a label
    func addLabel(_ label: String, leftSide left: Bool = false, forComponent component: Int, offsetFromComponent offset: CGFloat = 2, fontSize: Float = 20, fontStyle: FontStyle = .Light) -> UIView {
        
        let font = Const.makeFont(fontStyle, fontSize)!
        let textSize = (NSString(string: label)).size(withAttributes: [NSAttributedStringKey.font: font])
        let PaddingBetweenComponents: CGFloat = 5
        
        // determine where the component is in the x-axis
        var widthOfAllComponents: CGFloat = 0
        var widthOfThisComponent: CGFloat = 0
        var widthOfPriorComponents: CGFloat = (PaddingBetweenComponents * CGFloat(component))
        if let delegate = self.delegate {
            for i in 0...(self.dataSource!.numberOfComponents(in: self) - 1) {
                let width = delegate.pickerView!(self, widthForComponent: i)
                if i < component {
                    widthOfPriorComponents += width
                } else if i == component {
                    widthOfThisComponent = width
                }
                widthOfAllComponents += width
            }
        } else {
            pWarn ("No delegate found for \(self.dynamicTypeName), won't be able to correctly place labels")
        }
        
        
        
        
        // since the components will be centered, the first component will be at center - widthOfAll/2
        let startOfFirstComponent = self.center.x - widthOfAllComponents / 2
        
        // now that we know where our components start, offset the x to match the label for this component
        //      this will be the center of the component, positioning should be done with offset
        var x = startOfFirstComponent + widthOfPriorComponents + widthOfThisComponent / 2
        
        let y = self.frame.height/2 - textSize.height/2 - 1
        
        if left {
            x -= offset
        } else {
            x += offset
        }
        
        
        
        let labelView = UILabel()
        labelView.textAlignment = NSTextAlignment.left
        labelView.text = label
        labelView.font = font
        labelView.sizeToFit()
        labelView.frame = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
        self.addSubview(labelView)
        
        return labelView
    }    
}
