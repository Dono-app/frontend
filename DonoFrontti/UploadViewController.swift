//
//  UploadViewController.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import UIKit
import os.log

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var card: Card?
    
    var categoryValue: String = "1"
    
    var location = ""
    
    var categoryList = ["Clothes","Electronics","Furniture","Tools","Misc.",]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 248/255, green: 246/255, blue: 230/255, alpha: 1)
        
        tblView.isHidden = true
        
        photoImageView.image = UIImage(named: "noImage")
        
        saveButton.isEnabled = false
        
        nameTextField.delegate = self
        contactTextField.delegate = self
        locationTextField.delegate = self
        
        
        updateSaveButtonState()
    }
    
    @IBAction func onClickDropButton(_ sender: Any) {
        if tblView.isHidden {
            animate(toogle: true)
        }else{
            animate(toogle: false)
        }
    }
    
    func animate(toogle: Bool){
        if toogle {
            UIView.animate(withDuration: 0.3){
                self.tblView.isHidden = false
            }
        }else{
            UIView.animate(withDuration: 0.3){
                self.tblView.isHidden = true
                
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    @IBAction func importPhoto(_ sender: UIButton) {
            nameTextField.resignFirstResponder()
            contactTextField.resignFirstResponder()
            locationTextField.resignFirstResponder()
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            image.allowsEditing = false
            
            self.present(image, animated: true)
        
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoImageView.image = image
        }else{
            fatalError("Expected a dictionary containing image, but was provided following: \(info)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let categoryId = categoryValue
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let location = locationTextField.text ?? ""
        let contact = contactTextField.text ?? ""
        print ("catID: ", categoryId)
        
        card = Card(name: name, categoryId: categoryId, photo: photo, rating: rating, location: location, contact: contact)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: uimagepickercontrollerdelgate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    //MARK PRIVATE METHODS
    private func updateSaveButtonState(){
        let name = nameTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let contact = contactTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !location.isEmpty && !contact.isEmpty
    }

}

extension UploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdown", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDrop.setTitle("\(categoryList[indexPath.row])", for: .normal)
        animate(toogle: false)
        if categoryList[indexPath.row] == "Clothes"{
            self.categoryValue = "1"
        }
        if categoryList[indexPath.row] == "Electronics"{
            self.categoryValue = "2"
        }
        if categoryList[indexPath.row] == "Furniture"{
            self.categoryValue = "3"
        }
        if categoryList[indexPath.row] == "Tools"{
            self.categoryValue = "4"
        }
        if categoryList[indexPath.row] == "Misc."{
            self.categoryValue = "5"
        }
    }
}


