//
//  SMTextField.swift
//

import Foundation
import UIKit

/**
 - usage:
 Auto Complete:
     You must set this string array
     autoCompletionPossibilities
 
 Normal GenInput:
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
    case day  // use number pad
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
    func genInputDidBeginEditing(_ textField: UITextField)
    func genInputDidEndEditing(_ textField: UITextField)
}

@IBDesignable
open class GenInputField: UIView {
    
    // MARK: Support Auto Complete
    open var autoCompletionPossibilities: [String]? = nil
    var autoCompleteCharacterCount = 0

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
    @IBOutlet open weak var textField: UITextField!
    @IBOutlet open weak var placeImage: UIImageView!
    @IBOutlet weak var placeImgView: UIView!
    
    // right side button used for hide/show password
    @IBOutlet weak var rightButtonView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    
    // Shortcut to get textfield value
    open var text: String? {
        return textField.text
    }
    
    override open func updateConstraints() {
        switch self.mode {
        case .ImageAndTextField:
            placeImgView.isHidden = false
        case .TextFieldOnly:
            placeImgView.isHidden = true
        case .TextFieldOnlyNoEdge:
            placeImgView.isHidden = true
        }
        super.updateConstraints()
    }
    
    open var strokeColor: UIColor = UIColor.clear {
        didSet {
            self.setNeedsLayout()
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
    
    @IBInspectable open var isPassword: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = isPassword
            rightButtonView.isHidden = !isPassword
        }
    }
    
    open var passwordImgNameShow: String! = "" {
        didSet {
            updateSentitivePasswordImage()
        }
    }
    open var passwordImgNameHide: String! = "" {
        didSet {
            updateSentitivePasswordImage()
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
    
    /**
     Use this when not loading with storyboard
     
     - ex:
        let textField = GenInputField()
     */
    public init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init()
        }
        
        let name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        self.addSubview(view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                           options: NSLayoutFormatOptions.alignAllCenterY ,
                                           metrics: nil, views: ["view": self.view]))
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                           options: NSLayoutFormatOptions.alignAllCenterX,
                                           metrics: nil, views: ["view": self.view]))
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
        let len = placeholder.count
        
        if isPlaceholderCenterAlign {
            let centeredParagraphStyle = NSMutableParagraphStyle()
            centeredParagraphStyle.alignment = .center
            text.addAttribute(NSAttributedStringKey.paragraphStyle,
                              value: centeredParagraphStyle,
                              range: NSRange(location: 0, length: len))
        }
        
        if required {
            text = NSMutableAttributedString(string: "\(placeholder)*")
            text.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(len, 1))
        }
        
        text.addAttribute(NSAttributedStringKey.foregroundColor, value: placeholderTextColor, range: NSMakeRange(0, len))
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

    // MARK: - Right Button
    
    private func updateSentitivePasswordImage() {
            if textField.isSecureTextEntry {
            if let img = UIImage(named: passwordImgNameHide) {
                rightButton.setImage(img, for: .normal)
            }
        } else {
            if let img = UIImage(named: passwordImgNameShow) {
                rightButton.setImage(img, for: .normal)
            }
        }
    }

    @IBAction func actionRightButton(_ sender: Any) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        updateSentitivePasswordImage()
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
        delegate?.genInputDidBeginEditing(textField)
        
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
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        currentPickerValue = sender.date.toString(NSDateStringStyle.monthDayYear, timeZone: "UTC")
        textField.text = currentPickerValue
    }
    
    /**
     Picker done button
     */
    @objc func donePicker() {
        switch keyboardType {
        case .dateDayMonYear:
            textField.text = currentPickerValue
        default:
            break
        }
        textField.resignFirstResponder()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.placeholder = self.currentPlaceholderText
        delegate?.genInputDidEndEditing(textField)
    }
    
    /**
     Called when you hit done
     */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didPressReturn()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Auto Complete
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool
    {
        guard autoCompletionPossibilities != nil else {
            return true
        }
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 {
            // when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        textField.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        guard autoCompletionPossibilities != nil else {
            return
        }
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring)
        
        if suggestions.count > 0 {
            doOnMainAfterTime(0.01, block: {
                let autocompleteResult =  self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
            })
        } else {
            doOnMainAfterTime(0.01, block: {
                self.textField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
        
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String] {
        guard let autoCompletionPossibilities = autoCompletionPossibilities else {
            return []
        }
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities {
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSRange(location: userQuery.count, length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
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
