//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Rodrigo Carballo on 3/17/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bottomTextField.delegate = self
        self.topTextField.delegate = self
        
        //setting text atttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        
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
    
    
//actions
    @IBAction func pickAnImage(_ sender: Any) {
                
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
                
        imagePicker.sourceType = .photoLibrary
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
    
}

