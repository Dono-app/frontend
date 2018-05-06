//
//  Card.swift
//  DonoFrontti
//
//  Created by iosdev on 23.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import UIKit
class Card{
    //MARK:properties
    
    var name: String
    var photo: UIImage?
    var categoryId: String
    var rating: Int
    var location: String
    var contact: String
    var description: String
    
    // Initializing
    init?(name: String, categoryId: String, photo: UIImage?, rating: Int, location: String, contact: String, description: String){
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        self.name = name
        self.categoryId = categoryId
        self.photo = photo
        self.rating = rating
        self.location = location
        self.contact = contact
        
        self.description = description
    }
}
