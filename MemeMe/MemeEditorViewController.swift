//
//  ViewController.swift
//  MemeMe
//
//  Created by بدور on 05/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit

struct Meme {
    var topText : String?
    var bottomText : String?
    var originalImage : UIImage?
    var memedImage : UIImage?
}

class MemeEditorViewController : UIViewController , UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate{
    
    
   
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var nevBar: UINavigationBar!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // image after rendering to view
    var  memedImg : UIImage!
    
    // dictionary for text property
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.1]
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //initial setting for top text field
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.contentVerticalAlignment = .center
        topTextField.delegate = self
        //initial setting for bottom text field
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.contentVerticalAlignment = .center
        bottomTextField.delegate = self
        
        // disabling share button until user pick an image
         shareButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // disabling camera button for devices that dosnt have one
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Handleing Keyboard Notifications
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //Handleing Keyboard Notifications
        unsubscribeFromKeyboardNotifications()
    }

    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // clear text field if user click on
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM")
        {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
   
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImg)
    }
    
    func generateMemedImage() -> UIImage {
        
        //  Hide toolbar and navbar
      toolbar.isHidden = true
        nevBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.isHidden = false
        nevBar.isHidden = false
        
        return memedImage
    }
    
    
    @IBAction func share(_ sender: Any) {
        
        // get memed image
         memedImg = generateMemedImage()
        
        
        let controller = UIActivityViewController(activityItems: [memedImg], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                return
            }
             // activity complete
            self.save()
      
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    // cancel buttom action will reset intial value of text fields and image view
   @IBAction func cancel(_ sender: Any) {
      topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    imagePickerView.image = nil
   shareButton.isEnabled = false
    }
}

