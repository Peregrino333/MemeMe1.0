//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Rodrigo Carballo on 3/17/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    
//variables
    var activeTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bottomTextField.delegate = self
        self.topTextField.delegate = self
        
        //setting text atttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        
        //validating for simulator and disable camera button
        #if targetEnvironment(simulator)
        cameraButton.isEnabled = false
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
//Meme attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2.0]
    
//outlets
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
//actions
    @IBAction func pickAnImage(_ sender: Any) {
                
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]                
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ pickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    
        if let image = info[.originalImage] as? UIImage {
                imagePickerView.image = image
        }
            
        //save()
            
        dismiss(animated: true, completion: nil)
        }
        
    func imagePickerControllerDidCancel(_ pickerController: UIImagePickerController)
        {
            dismiss(animated: true, completion: nil)
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.text = ""
            
            print("I am on text field")
            
            // we don't need to move the view up
            self.activeTextField = textField
            
        }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true;
        }

    
//keyboard notification
    
    func subscribeToKeyboardNotifications() {

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        }

    func unsubscribeFromKeyboardNotifications() {

            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc func keyboardWillShow(_ notification:Notification) {
            
            if (self.activeTextField == topTextField) {
                view.frame.origin.y -= 0
            }
            else {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
    }
        
    @objc func keyboardWillHide(_ notification:Notification) {

              view.frame.origin.y = 0
        }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }

    
    
}

