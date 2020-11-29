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
        
        nameField.text = item.name
        creatorField.text = item.creator
        timeField.text = item.timeRequired
//        dateLabel.text = DateFormatter.string(from: "10/13/2020")
        dateLabel.text = "today"
        ingredientsField.text = item.ingredients
//        var ingredientsText = ""
//        for i in 0...item.ingredients.count - 1{
//            ingredientsText += "- \(item.ingredients[i])\n"
//            print(ingredientsText)
//        }
//        ingredientsField.text = ingredientsText
        
        // Get the item key
        let key = item.itemKey
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save changes to item
        item.name = nameField.text ?? ""
        item.timeRequired = timeField.text ?? "0"
        item.ingredients = ingredientsField.text ?? ""
//        var ingredientsText: String
//        if let val = ingredientsField.text {
//            ingredientsText = val
//            let ingredients = ingredientsText.components(separatedBy: "- ")
//            item.ingredients = []
//            for i in 0...ingredients.count - 1 {
//                if (ingredients[i] != "") {
//                    let trimmed = ingredients[i].components(separatedBy: "\n")
//                    print(trimmed)
//                    item.ingredients.append(trimmed[0])
//                }
//            }
//        }
    
        
        if let creatorText = creatorField.text {
            item.creator = creatorText
        } else {
            item.creator = "Anonymous"
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
        itemStore.removeItem(self.item)
        imageStore.deleteImage(forKey: item.itemKey)
        self.navigationController?.popViewController(animated: true)
        
    }
}
