//
//  SMTextField.swift
//

import Foundation
import UIKit

/**
 - usage:
 
 Normal GenInput
     input.setupWith(.clearBkgLightBorderBlackText, .shipNotShownPlaceholder)
     input.textField.returnKeyType = UIReturnKeyType.done
 
 Date Input:
     dateInput.setupWith(.clearBkgLightBorderBlackText, .datePickerPlaceholder)
     dateInput.pickerToolbarTintColor = SMColor.NavBlue_106
     dateInput.keyboardType = .dateDayMonYear
 */

//public enum GenInputFieldType: String {
//    case Date
//    case String
//    case Email
//    case PhoneNumber
//    case Number
//    case Unknown
//    static let values: [GenInputFieldType] = [Date, String, Email,
//        PhoneNumber, Number, Unknown]
//}

public enum GenInputFieldType {
    case string
    case number // number keyboard
    case dateDayMonYear // date picker
    case day
}

public enum GenInputFieldMode: String {
    case ImageAndTextField
    // Has border of 20 on lead and tail
    case TextFieldOnly
    // Has border of 0 on all sides
    case TextFieldOnlyNoEdge
}

public protocol GenInputFieldDelegate: class {
    func didPressReturn()
}

@IBDesignable
open class GenInputField: UIView {
    fileprivate var view: UIView!
    var currentPlaceholderText: String = ""
    open var mode: GenInputFieldMode = .ImageAndTextField
    open weak var delegate: GenInputFieldDelegate? = nil
    
    open var keyboardType: GenInputFieldType = .string {
        didSet {
            switch keyboardType {
            case .string:
                self.textField.keyboardType = .default
            case .number:
                self.textField.keyboardType = .numberPad
                self.addToolbar()
            case .day: fallthrough
            case .dateDayMonYear:
                // but not used we just set as default
                self.textField.keyboardType = .default
                self.addToolbar()
            }
        }
    }
    
    open var capitalType: UITextAutocapitalizationType = .none {
        didSet {
            self.textField.autocapitalizationType = capitalType
        }
    }
    
    open var pickerToolbarTintColor: UIColor = .lightGray
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var placeImageWidth: NSLayoutConstraint!
    @IBOutlet open weak var textField: UITextField!
    @IBOutlet open weak var placeImage: UIImageView!

    @IBOutlet weak var leadingEdge: NSLayoutConstraint!
    @IBOutlet weak var tailEdge: NSLayoutConstraint!
    @IBOutlet weak var topEdge: NSLayoutConstraint!
    @IBOutlet weak var bottomEdge: NSLayoutConstraint!
    
    override open func updateConstraints() {
        switch self.mode {
        case .ImageAndTextField:
            placeImage.isHidden = false
            placeImageWidth.constant = 20
            textFieldLeading.constant = 8
        case .TextFieldOnly:
            placeImage.isHidden = true
            placeImageWidth.constant = 0
            textFieldLeading.constant = 0
        case .TextFieldOnlyNoEdge:
            placeImage.isHidden = true
            placeImageWidth.constant = 0
            textFieldLeading.constant = 0
            
            topEdge.constant = 5
            bottomEdge.constant = 5
            leadingEdge.constant = 5
            tailEdge.constant = 5
        }
        super.updateConstraints()
    }
    
    open var strokeColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var isPassword: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = isPassword
        }
    }
    
    @IBInspectable open var placeholder: String! = "" {
        didSet {
            updatePlaceholderText()
        }
    }
    
    public var placeholderTextColor: UIColor = UIColor(hex: "#FFFFFF", alpha: 75)
    
    open var isPlaceholderCenterAlign: Bool = false {
        didSet {
            updatePlaceholderText()
        }
    }
    
    @IBInspectable open var placeholderImage: String! = ""  {
        didSet {
            updatePlaceholderImage()
        }
    }
    
    @IBInspectable open var required: Bool = false {
        didSet {
            updatePlaceholderText()
        }
    }
    
    /// Corner radius of the background rectangle
    open var cornerRadius: CGFloat = 2 {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var borderWidth: CGFloat = 2.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    open var bkgColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open var bkgColorForView: UIColor = UIColor.clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if view == nil {
            xibSetup()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if view == nil {
            xibSetup()
        }
    }
    
    func xibSetup() {
        self.backgroundColor = UIColor.clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        updatePlaceholderText()
        
        // hide quicktype
        // http://stackoverflow.com/questions/25951274/disable-ios8-quicktype-keyboard-programmatically-on-uitextview
        //
        self.textField.autocorrectionType = UITextAutocorrectionType.no
        
        self.textField.delegate = self
        

        
        // set return button to Done
//        self.textField.returnKeyType = UIReturnKeyType.Done

        // check for taps
//        let tap = UITapGestureRecognizer(target: self, action: "dropDownImageTapped:")
//        tap.numberOfTapsRequired = 1
//        tap.numberOfTouchesRequired = 1
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.dynamicTypeName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    fileprivate func updatePlaceholderText() {
        var text = NSMutableAttributedString(string: placeholder)
        let len = placeholder.characters.count
        
        if isPlaceholderCenterAlign {
            let centeredParagraphStyle = NSMutableParagraphStyle()
            centeredParagraphStyle.alignment = .center
            text.addAttribute(NSParagraphStyleAttributeName,
                              value: centeredParagraphStyle,
                              range: NSRange(location: 0, length: len))
        }
        
        if required {
            text = NSMutableAttributedString(string: "\(placeholder)*")
            text.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(len, 1))
        }
        
        text.addAttribute(NSForegroundColorAttributeName, value: placeholderTextColor, range: NSMakeRange(0, len))
        textField.attributedPlaceholder = text
        self.currentPlaceholderText = placeholder
    }
    
    fileprivate func updatePlaceholderImage() {
        self.placeImage.image = UIImage(named: placeholderImage)
    }
    
    // called after setNeedsLayout to update the view, mainly used for IB adjustments
    //
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        view.layer.cornerRadius = self.cornerRadius
        view.layer.masksToBounds = true
        view.layer.borderColor = self.strokeColor.cgColor
        view.layer.borderWidth = self.borderWidth
        
        view.backgroundColor = self.bkgColorForView
        self.contentView.backgroundColor = self.bkgColor
    }
    
    // MARK: - Utility
    
    func addToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.backgroundColor = pickerToolbarTintColor
        toolBar.barTintColor = pickerToolbarTintColor
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(GenInputField.donePicker))
        let f1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let f2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([f1, f2, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    public func setBottomBorder(borderColor: UIColor = .white) {
        textField.setBottomBorder(borderColor: borderColor)
    }
    
    // MARK: Picker Stuff
    var currentPickerValue: String = ""
}

// MARK: - UITextFieldDelegate

extension GenInputField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.placeholder = nil
        
        switch keyboardType {
        case .dateDayMonYear:
            // MARK: Setup Picker
            let datePickerView: UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.timeZone = TimeZone(abbreviation: "UTC")
            textField.inputView = datePickerView
            datePickerView.addTarget(self,
                                     action: #selector(GenInputField.datePickerValueChanged),
                                     for: UIControlEvents.valueChanged)
            currentPickerValue = datePickerView.date.toString(NSDateStringStyle.monthDayYear, timeZone: "UTC")
        default:
            break
        }
    }
    
    /**
     When we use the picker, and the value changes
     */
    func datePickerValueChanged(sender: UIDatePicker) {
        currentPickerValue = sender.date.toString(NSDateStringStyle.monthDayYear, timeZone: "UTC")
        textField.text = currentPickerValue
    }
    
    /**
     Picker done button
     */
    func donePicker() {
        textField.text = currentPickerValue
        textField.resignFirstResponder()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.placeholder = self.currentPlaceholderText
    }
    
    /**
     Called when you hit done
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didPressReturn()
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Setup UI

extension GenInputField {
    
    /**
     http://imgur.com/a/Sa2Zg
     */
    public func setupUIUnderline(backgroundColor: UIColor,
                          borderColor: UIColor = .white)
    {
        self.mode = .TextFieldOnlyNoEdge
        
        // must clear before set bottom border
        self.bkgColorForView = UIColor.clear
        self.setBottomBorder(borderColor: borderColor)
        
        self.textField.backgroundColor = backgroundColor
        self.bkgColor = backgroundColor
    }
}
