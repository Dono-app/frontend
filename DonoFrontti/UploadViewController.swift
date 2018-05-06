//
//  UploadViewController.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import UIKit
import os.log
import CoreML
import Vision

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var card: Card?
    
    var imageRec: String = ""
    
    var categoryValue: String = "5"
    
    var location = ""
    
    var categoryList = ["Clothes","Electronics","Furniture","Tools","Misc.",]
    
    var titleText: String = "Add New"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 248/255, green: 246/255, blue: 230/255, alpha: 1)
        navigationItem.title = titleText
        tblView.isHidden = true
        photoImageView.image = UIImage(named: "noImage")
        saveButton.isEnabled = false
        nameTextField.delegate = self
        contactTextField.delegate = self
        locationTextField.delegate = self
        descriptionTextField.delegate = self
        
    //Card editing
        if let card = card {
            navigationItem.title = card.name
            nameTextField.text   = card.name
            photoImageView.image = card.photo
            ratingControl.rating = card.rating
            categoryValue = card.categoryId
            locationTextField.text = card.location
            contactTextField.text = card.contact
            descriptionTextField.text = card.description
        }
        updateSaveButtonState()
    }
    
    // Image recognition
    func detectImageContent() {
        
        guard let model = try? VNCoreMLModel(for: realdonomodel().model)
            else{
                fatalError("failed to load model")
        }
        
        let request = VNCoreMLRequest(model: model){[weak self] request,error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else{
                    fatalError("unexpected results")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.imageRec = "\(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence)"
                print("wololoo: ", self?.imageRec)
                print(topResult.identifier)
                
                // 4 = shirts
                // 5 = shoes
                if topResult.identifier == "4" || topResult.identifier == "5"{
                    self?.btnDrop.setTitle("Clothes", for: .normal)
                    self?.categoryValue = "1"
                }
                
                // 1 = laptops
                // 2 = phones
                if topResult.identifier == "1" || topResult.identifier == "2"{
                    self?.btnDrop.setTitle("Electronics", for: .normal)
                    self?.categoryValue = "2"
                }
                
                // 0 = chairs
                // 6 = sofas
                // 7 = tables
                if topResult.identifier == "0" || topResult.identifier == "6" || topResult.identifier == "7"{
                    self?.btnDrop.setTitle("Furniture", for: .normal)
                    self?.categoryValue = "3"
                }
                
                // 3 = screwdrivers
                // 9 = wrenches
                if topResult.identifier == "3" || topResult.identifier == "9"{
                    self?.btnDrop.setTitle("Tools", for: .normal)
                    self?.categoryValue = "4"
                }
                
                // 8 = watches
                if topResult.identifier == "8" {
                    self?.btnDrop.setTitle("Misc", for: .normal)
                    self?.categoryValue = "5"
                }
                
            }
        }
        
        guard let ciImage = CIImage(image: photoImageView.image!)
            else{ fatalError("cant create image")}
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    //Dropdown menu
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
    
    // Select image
    @IBAction func importPhoto(_ sender: UIButton) {
            nameTextField.resignFirstResponder()
            contactTextField.resignFirstResponder()
            locationTextField.resignFirstResponder()
            descriptionTextField.resignFirstResponder()
        
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoImageView.image = image
        }else{
            fatalError("Expected a dictionary containing image, but was provided following: \(info)")
        }
        self.dismiss(animated: true, completion: nil)
        detectImageContent()
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
        let description = descriptionTextField.text ?? ""
        
        print ("catID: ", categoryId)
        card = Card(name: name, categoryId: categoryId, photo: photo, rating: rating, location: location, contact: contact, description: description)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
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
        let description = descriptionTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !location.isEmpty && !contact.isEmpty && !description.isEmpty
    }
}

//Extensions
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


