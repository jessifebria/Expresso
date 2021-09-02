//
//  AddViewController.swift
//  Expresso
//
//  Created by Jessi Febria on 01/05/21.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButtonOutlet.isHidden = true
        nameInput.delegate = self
        imagePicker.delegate = self
        imagePreview.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameInput.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameInput.backgroundColor = UIColor.white
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nameInput.backgroundColor = UIColor.white
    }
    
    
    @IBAction func choseImageButton(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("loading picture")
        
        if let imageChosen = info[.originalImage] as? UIImage {
            imagePreview.isHidden = false
            imagePreview.contentMode = .scaleAspectFit
            imagePreview.image = imageChosen
            
        }
        saveButtonOutlet.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let name = nameInput.text, name != "" else {
            nameInput.backgroundColor = UIColor(red: 240/255.0, green: 0.0, blue: 0.0, alpha: 0.2)
            nameInput.placeholder = "You must fill person's name!"
            return
        }
    
        PersonService().savePerson(name: name, image: imagePreview.image!)
        performSegue(withIdentifier: "unwindToHomepage", sender: sender)
    }
}
