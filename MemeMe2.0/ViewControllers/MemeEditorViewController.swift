//
//  MemeEditorViewController.swift
//  MemeMe1.0
//
//  Created by khawlah on 11/19/18.
//  Copyright © 2018 khawlah. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var AlbumButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    @IBOutlet weak var Toolbar: UIToolbar!
   
    @IBOutlet weak var Toolbar1: UIToolbar!
    
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK:  setting the initial text of textFields
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setText(textField: TopTextField, string: "TOP")
        setText(textField: BottomTextField, string: "BOTTOM")
        
        ShareButton.isEnabled = false
        imagePicker.delegate = self
        
    }
 
    //MARK:  Pick an image from photoLibrary
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:  Pick an image from camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: is called when view is loading
    func setText (textField: UITextField, string: String){
        //textField.text = string.uppercased()
        textField.defaultTextAttributes = memeMeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.borderStyle = .none
        textField.autocapitalizationType = .allCharacters
    }
    
    //MARK: setting font style and color
    let memeMeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40 )!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3.0]
    
    
    //MRAK: subscribe To Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }
    
    //MRAK: unsubscribe To Keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
 
    //MARK: keyboard Will Show
    @objc private func keyboardWillShow(_ notification:Notification) {
        if BottomTextField.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //MARK: get keyboard Height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    // MARK: hide keyboard
    @objc private func keyboardWillHide(_ notification: Notification) {
            view.frame.origin.y = 0.0
    }

    //MARK: generate MemedImage (Combining image and text)
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        Toolbar.isHidden = true
        Toolbar1.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show toolbar and navbar
        Toolbar.isHidden = false
        Toolbar1.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        return memedImage
    }
    
    //MARK: Sharing Action Method
    @IBAction func activityViewController(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage] , applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = {activity, completed, items, error -> Void in
            if completed{
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    //MARK: saving the memedImage
    func save(memedImage: UIImage){
        // Create the meme
       let meme = memeMe(topText: TopTextField.text!, bottomText: BottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage )
        
        // Add it to the memes array on the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        }
 
    //MARK: return to sent memes
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
}

extension MemeEditorViewController: UITextFieldDelegate {
    //MARK: textField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: begin editing in textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "TOP" ||  textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   //MARK: image Picker Controller
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
       if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imagePickerView.image = image
        imagePickerView.contentMode = .scaleAspectFit
        ShareButton.isEnabled = true
     }
     dismiss(animated: true, completion: nil)
   }
}


