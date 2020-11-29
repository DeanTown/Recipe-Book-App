//
//  DetailViewController.swift
//  Recipe Book
//
//  Created by Oliver Reckord Groten on 11/5/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var creatorField: UITextField!
    @IBOutlet var timeField: UITextField!
    @IBOutlet var ingredientsField: UITextView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    var itemStore: ItemStore!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ingredientsField.layer.borderWidth = 1
        ingredientsField.layer.cornerRadius = 5
        
        if (item != nil) {
            nameField.text = item.name
            creatorField.text = item.creator
            timeField.text = item.timeRequired
            ingredientsField.text = item.ingredients
            // Get the item key
            let key = item.itemKey
            // If there is an associated image with the item
            // display it on the image view
            let imageToDisplay = imageStore.image(forKey: key)
            imageView.image = imageToDisplay
        } else {
            print(item)
//            item = itemStore.createItem()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save changes to item
        if (nameField.text == "" && ingredientsField.text == "" && timeField.text == "") {
            itemStore.removeItem(item)
            print("ITEM NOT INITIALIZED - REMOVING")
        } else {
            item.name = nameField.text ?? ""
            item.timeRequired = timeField.text ?? "0"
            item.ingredients = ingredientsField.text ?? ""
            
            if let creatorText = creatorField.text {
                item.creator = creatorText
            } else {
                item.creator = "Anonymous"
            }
            print("ITEM DATA SAVED")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        
        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        // Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        // Get picked image from the info dictionary
        let image = info[.originalImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        
        // Take image picker off the screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        let title = "Delete \(item.name)?"
        let message = "Are you sure you want to delete this item?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive,
                                         handler: { (action) -> Void in
                                            self.itemStore.removeItem(self.item)
                                            self.imageStore.deleteImage(forKey: self.item.itemKey)
            self.navigationController?.popViewController(animated: true)
        })
        ac.addAction(deleteAction)
        
        // Present the alert controller
        present(ac, animated: true, completion:  nil)
        
        
    }
}
