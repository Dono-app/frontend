//
//  Listing.swift
//  DonoFrontti
//
//  Created by iosdev on 30.4.2018.
//  Copyright © 2018 default. All rights reserved.
//

import Foundation

class Listing{
    //MARK: Properties
    var image: String
    var rating: String
    var description: String
    var location: String
    var tel: String
    var listingName: String
    var listingId: String
    var userId: String
    var categoryId: String
    var email: String
    
    //MARK: Initializer
    init(image: String, rating: String, description: String, location: String, tel: String, listingName: String, listingId: String, userId: String,
         categoryId: String, email: String){
        self.image = image
        self.rating = rating
        self.description = description
        self.location = location
        self.tel = tel
        self.listingName = listingName
        self.listingId = listingId
        self.userId = userId
        self.categoryId = categoryId
        self.email = email
    }
}
