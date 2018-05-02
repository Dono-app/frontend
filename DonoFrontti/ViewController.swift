//
//  ViewController.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let uploaderi = UploadImage()
    let imageInfo = SendImageInfo()

    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    @IBAction func categoryControlPressed(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            tableView.backgroundColor = UIColor.blue
        }else{
            tableView.backgroundColor = UIColor.orange
        }
        
    }
    
    var cards = [Card]()
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 248/255, green: 246/255, blue: 230/255, alpha: 1)
        
        loadSampleCards()
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //Sample cards ----------------------------
    private func loadSampleCards(){
        let sample1 = UIImage(named: "Sample1")
        
        guard let sampleC1 = Card(name: "Vitun hyvät sukat", photo: sample1, rating: 3, location: "Evijärvi", contact: "juhopes@metropolia.fi") else {
            fatalError("Unable to instantiate sample 1")
        }
        
        cards += [sampleC1]
    }
    //----------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cards.count
    }
    
    let cellIdentifier = "CardTableViewCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CardTableViewCell
        
        
        cell.contentView.backgroundColor = UIColor(red: 248/255, green: 246/255, blue: 230/255, alpha: 1)
        
        
        let card = cards[indexPath.row]
        
        cell.nameLabel.text = card.name
        cell.photoImageView.image = card.photo
        cell.ratingControl.rating = card.rating
        cell.locationLabel.text = card.location
        cell.contactLabel.text = card.contact
        
        return cell
    }
    
    @IBAction func unwindToCardList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? UploadViewController, let card = sourceViewController.card {
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: cards.count, section: 0)
            
            cards.append(card)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            uploaderi.upload(image: card.photo!)
            imageInfo.sendImageJson(name: card.name, location: card.location, contact: card.contact)
            imageInfo.getJSON()
            
        }
    }
    
    
    
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        print ("unwinding from \(unwindSegue.destination)")
    }
    
    
    

}

