//
//  ViewController.swift
//  MemeMe
//
//  Created by dmikhov on 25.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var pickFromCameraButtonView: UIButton!

    @IBOutlet var defaultIconView: UIImageView!
    @IBOutlet var containerImageView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pickFromGalleryButtonView: UIButton!
    @IBOutlet var topTextView: UITextField!
    @IBOutlet var botTextView: UITextField!
    @IBOutlet var clearButtonView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        topTextView.delegate = self
        botTextView.delegate = self
        
        pickFromGalleryButtonView.addTarget(self, action: #selector(pickAnImageFromGallery), for: UIControlEvents.touchUpInside)
        pickFromCameraButtonView.addTarget(self, action: #selector(pickAnImageFromCamera), for: UIControlEvents.touchUpInside)
        clearButtonView.addTarget(self, action: #selector(clear), for: UIControlEvents.touchUpInside)
        
        renderTextViews()
        
        let shareActionButton: UIBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = shareActionButton
        
        prepareCircularDefaultImage(image: defaultIconView)
        
        self.tabBarController?.tabBar.isHidden = true
        
        renderNotOpenedMode()
    }
    
    func prepareCircularDefaultImage(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
    }
    
    func renderNotOpenedMode() {
        pickFromGalleryButtonView.isHidden = false
        pickFromCameraButtonView.isHidden = false
        defaultIconView.isHidden = false
        
        clearButtonView.isHidden = true
        topTextView.isHidden = true
        botTextView.isHidden = true
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func renderOpenedMode() {
        pickFromGalleryButtonView.isHidden = true
        pickFromCameraButtonView.isHidden = true
        defaultIconView.isHidden = true
        
        clearButtonView.isHidden = false
        topTextView.isHidden = false
        botTextView.isHidden = false
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func pickAnImageFromGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        renderOpenedMode()
    }
    
    func pickAnImageFromCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
            
            renderOpenedMode()
        }
    }
    
    func clear() {
        imageView.image = nil
        topTextView.text = nil
        botTextView.text = nil
        renderNotOpenedMode()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
        } else {
            print("Something went wrong!")
        }
    }
    
    func renderTextViews() {
        let helvetica = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let attributes:[String:Any] = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : NSNumber(value: -4.0),
            NSFontAttributeName: helvetica
        ]
        let hintAttributes:[String:Any] = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.lightGray,
            NSStrokeWidthAttributeName : NSNumber(value: -4.0),
            NSFontAttributeName: helvetica
        ]
        
        
        topTextView.defaultTextAttributes = attributes
        botTextView.defaultTextAttributes = attributes
        
        topTextView.textAlignment = .center
        botTextView.textAlignment = .center
        
        topTextView.attributedPlaceholder = NSAttributedString(string: "TOP TEXT", attributes: hintAttributes)
        botTextView.attributedPlaceholder = NSAttributedString(string: "BOTTOM TEXT", attributes: hintAttributes)
    }
    
    func share() {
        if(topTextView.text != nil && topTextView.text != "" && botTextView.text != nil && botTextView.text != "") {
            let text = "Hey! I've done something funny!"
            let memedImage = generateMemedImage()
            // set up activity view controller
            let textToShare = [ text, memedImage   ] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            save(memedImage: memedImage)
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hold on cowboy", message: "You should fill top and bottom fields first", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topTextView.text!, botTextView.text!, imageView.image!, memedImage)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.memes.append(meme)
        print("save")
        for meme in (appDelegate?.memes)! {
            print(meme.topText)
        }
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.containerImageView.frame.size)
        self.containerImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }

    // MARK: KEYBOARD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if(!topTextView.isEditing) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    print("keyboardSize.height: ", keyboardSize.height)
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if(!topTextView.isEditing) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
    }

}

