//
//  ViewController.swift
//  MemeMe
//
//  Created by dmikhov on 25.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var containerImageView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonView: UIButton!
    @IBOutlet var topTextView: UITextField!
    @IBOutlet var botTextView: UITextField!
    @IBOutlet var buttonShare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        topTextView.delegate = self
        botTextView.delegate = self
        
        buttonView.addTarget(self, action: #selector(pickAnImageFromGallery), for: UIControlEvents.touchUpInside)
        buttonShare.addTarget(self, action: #selector(share), for: UIControlEvents.touchUpInside)
        
        renderTextViews()
    }

    
    func pickAnImageFromGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func pickAnImageFromCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        }
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
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            NSForegroundColorAttributeName: UIColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: Float(20)]
        
        let helvetica = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let attributes:[String:Any] = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : NSNumber(value: -4.0),
            NSFontAttributeName: helvetica
        ]
        
        topTextView.defaultTextAttributes = attributes
        botTextView.defaultTextAttributes = attributes
        
        topTextView.textAlignment = .center
        botTextView.textAlignment = .center
    }
    
    func share() {
        let text = "This is some text that I want to share."
        let memedImage = generateMemedImage()
        
        // set up activity view controller
        let textToShare = [ text, memedImage   ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topTextView.text!, botTextView.text!, imageView.image!, memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        buttonShare.isHidden = true
        buttonView.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.containerImageView.frame.size)
        
//        self.containerImageView.drawHierarchy(in: self.containerImageView.frame, afterScreenUpdates: true)
//        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        self.containerImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        buttonShare.isHidden = false
        buttonView.isHidden = false
        
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

