//
//  AddPizzaViewController.swift
//  Focacia
//
//  Created by Егор on 12/18/16.
//  Copyright © 2016 Yegor's Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage

class AddPizzaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var pizzaScrollView: UIScrollView!
    @IBOutlet weak var ingredientsField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    var pickerView = UIPickerView()
    var Categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        let addImageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdd(sender:)))
        
        addImageTap.delegate = self
        imageView.addGestureRecognizer(addImageTap)
        imageView.isUserInteractionEnabled = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
    }
    
    
    func configureKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        pizzaScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }


    @IBAction func dissmissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func dismissKeyboard(){
        self.view.endEditing(false)
        pickerView.isHidden = true
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    func handleAdd(sender: UITapGestureRecognizer? = nil) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Picker canceled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func didPressDone(_ sender: UIButton) {
        if (imageView.image != nil && nameField.text != "" && ingredientsField.text != ""){
            // Adding activity indicator
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.center = self.view.center
            self.view.addSubview(indicator)
            indicator.startAnimating()
            //
            let ref = FIRDatabase.database().reference().child("Food").child("Pizza")
            // Dealing with
            let photoName = UUID.init().uuidString
            let storageRef = FIRStorage.storage().reference(withPath: "\(photoName).jpg")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.put(UIImageJPEGRepresentation(imageView.image!, 0.6)!, metadata: uploadMetadata) { (metadata,error) in
                if error == nil {
                    print("Uploaded")
                    let post = ["picName" : "\(photoName).jpg",
                                "name" : self.nameField.text ?? "None",
                                "ingredients" : self.ingredientsField.text ?? "No ingredients",
                                "pic" : metadata?.downloadURL()?.absoluteString ?? "didnt get the link"]
                    ref.child(post["name"]!).setValue(post)
                }else{
                    print("Here is some \(metadata)")
                }
                indicator.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
            }
            //
        }else{
            let alert = UIAlertController(title: "Hey", message: "You forgot to fill the fields and choose image!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func loadCategories(){
        let ref = FIRDatabase.database().reference().child("Food")
        
        ref.observe(.value, with: { (snapshot) in
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot{
                self.Categories.append(snap.key)
            }
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Categories[row]
    }
}
