//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Rodrigo Carballo on 3/17/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
 
struct Meme {
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    }
    
    
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
        
        //initial text field values
        bottomTextField.text = "BOTTOM"
        topTextField.text = "TOP"
        
        //validating for simulator and disable camera button
        #if targetEnvironment(simulator)
        cameraButton.isEnabled = false
        #endif
        
        shareButton.isEnabled = false
        
        //restarting
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
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
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ pickerController: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    
        if let image = info[.originalImage] as? UIImage {
                imagePickerView.image = image
                shareButton.isEnabled = true
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
    
    //meme object section
        
    func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        }
        
    func generateMemedImage() -> UIImage {
            
        //hide toolbar and navbar
        self.navigationController?.toolbar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
            
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        //show toolbar and navbar
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

        return memedImage
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
                
        //save the meme
        //Completion handler
        controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
                print("saved")
                return
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    }
    
    //clicking cancel button
    @IBAction func cancelButton(_ sender: Any) {
        //initial text field values
        bottomTextField.text = "BOTTOM"
        topTextField.text = "TOP"
        
        imagePickerView.image = nil
        
    }
    
 
}

