//
//  ViewController.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let uploaderi = UploadImage()
    let imageInfo = SendImageInfo()
    var cards = [Card]()
    

    @IBOutlet weak var categoryControl: UISegmentedControl!
    
    @IBAction func categoryControlPressed(_ sender: UISegmentedControl) {
        var i : Int = sender.selectedSegmentIndex + 1
            cards.removeAll()
            print(sender.selectedSegmentIndex)
            uploaderi.paskea(catNo : "\(i)")
            cards.append(contentsOf: uploaderi.categoryCards)
            uploaderi.categoryCards.removeAll()
            self.tableView.reloadData()
            let scrollPoint = CGPoint(x: 0, y: tableView.contentSize.height - tableView.frame.size.height + 66)
            tableView.setContentOffset(scrollPoint, animated: false)
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 248/255, green: 246/255, blue: 230/255, alpha: 1)
        
        
        tableView.contentInset = UIEdgeInsetsMake(0,0,66,0)
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat(M_PI)))
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, tableView.bounds.size.width - 8.0)
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        uploaderi.getAllImages()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    private func getImagesByCategory(){
        cards.removeAll()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cards.count
    }
    
    let cellIdentifier = "CardTableViewCell"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CardTableViewCell
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
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
            
            
            // ------------------- EDIT JUTTUJA ---------
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                cards[selectedIndexPath.row] = card
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                //self.tableView.reloadData()
                
            } else {
            
            // ---------------------------------
            
            uploaderi.upload(image: card.photo!, listingName: card.name, category: card.categoryId, condition: card.rating, location: card.location, contact: card.contact)
                
            imageInfo.getJSON()
            
            self.tableView.reloadData()
            }
        }
    }
    
    // ---------- EDIT JUTTUJA --------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddListing":
            os_log("Adding a new item", log: OSLog.default, type: .debug)
            
        case "ShowDetails":
            os_log("Editing existing listing", log: OSLog.default, type: .debug)
            
            guard let itemDetailViewController = segue.destination as? UploadViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? CardTableViewCell
                else {
                    fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell)
                else {
                    fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = cards[indexPath.row]
            itemDetailViewController.card = selectedItem
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
    }
    
    // -------------------------------------------------------

    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        print ("unwinding from \(unwindSegue.destination)")
    }
}

