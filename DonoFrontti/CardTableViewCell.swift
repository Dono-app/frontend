//
//  CardTableViewCell.swift
//  DonoFrontti
//
//  Created by iosdev on 24.4.2018.
//  Copyright © 2018 default. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
}


