//
//  GenImagePicker.swift
//  RAB
//
//  Created by RAB on 11/10/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol GenImagePickerDelegate: class {
    func didFinishPickingImage(_ image: UIImage)
    func cancelPickingImage()
    func cancelActionSheet()
    
    // If implemented then the menu will show Clear Photo
    @objc optional func clearPhoto()
}

open class GenImagePicker: NSObject {
    
    open weak var delegate: GenImagePickerDelegate?
    var alert: UIAlertController!
    
    /**
     * Displays the image picker alert
     *
     * iPad Use: 
     * showPopOverOnView: pass the uibutton or uiview, and the popover
     * will display on this item.
     */
    open func show(_ viewController: UIViewController,
                   showPopOverOnView: UIView? = nil,
                   useClearPhoto: Bool = false) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { [weak self] (action) -> Void in
            guard let sSelf = self else { return }
            sSelf.delegate?.cancelActionSheet()
        }
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default)
        { [weak self] (action) -> Void in
            guard let sSelf = self else { return }
            sSelf.captureFromCamera(viewController)
        }
        
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default)
        { [weak self] (action) -> Void in
            guard let sSelf = self else { return }
            sSelf.selectImageFromGallery(viewController)
        }
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        
        // only add if delegate is added
        if useClearPhoto == true && self.delegate?.clearPhoto != nil {
            let clearPhotoAction = UIAlertAction(title: "Clear Photo", style: .default)
            { [weak self] (action) -> Void in
                guard let sSelf = self else { return }
                sSelf.delegate?.clearPhoto?()
            }
            alert.addAction(clearPhotoAction)
        }
        
        if let presenter = alert.popoverPresentationController {
            if let rightButton = viewController.navigationItem.rightBarButtonItem {
                presenter.barButtonItem = rightButton
            } else if let v = showPopOverOnView {
                presenter.sourceView = v
                presenter.sourceRect = v.bounds
            } else {
                presenter.sourceView = viewController.view
                presenter.sourceRect = viewController.view.bounds
            }
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    var customizeLook: [String: AnyObject]!
    
    /**
     call this on the object to add color customizations
     
     - parameter translucent:              Translucent Background
     - parameter barTintColor:             Background color
     - parameter tintColor:                Cancel button ~ any UITabBarButton items
     - parameter titleTextAttributesColor: Title color
     */
    open func addCustomizeLook(_ translucent: Bool, barTintColor: UIColor,
        tintColor: UIColor, titleTextAttributesColor: UIColor ) {
        customizeLook = ["translucent": translucent as AnyObject, "barTintColor": barTintColor,
            "tintColor": tintColor, "titleTextAttributesColor": titleTextAttributesColor]
    }
    
    fileprivate func customizeImagePicker(_ imagePicker: UIImagePickerController) {
        if customizeLook != nil {
            imagePicker.navigationBar.isTranslucent = customizeLook["translucent"] as! Bool
            imagePicker.navigationBar.barTintColor = customizeLook["barTintColor"] as? UIColor
            imagePicker.navigationBar.tintColor = customizeLook["tintColor"] as? UIColor
            imagePicker.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : customizeLook["titleTextAttributesColor"] as! UIColor
            ] // Title color
        }
    }
    
    deinit {
        pln()
    }
    
    func captureFromCamera(_ viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            pln("Button capture")
            let imag = UIImagePickerController()
            customizeImagePicker(imag)
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.camera
            imag.allowsEditing = false
            viewController.present(imag, animated: true, completion: nil)
        }
    }
    
    func selectImageFromGallery(_ viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            pln("Button capture")
            let imag = UIImagePickerController()
            customizeImagePicker(imag)
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imag.allowsEditing = false
            viewController.present(imag, animated: true, completion: nil)
        }
    }
}

extension GenImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.delegate?.didFinishPickingImage(image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.cancelPickingImage()
    }
}
