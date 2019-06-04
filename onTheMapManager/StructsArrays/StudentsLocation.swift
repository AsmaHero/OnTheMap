//
//  LocationResults.swift
//  onTheMap
//
//  Created by Asmahero on ١٦ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
struct StudentsLocation: Codable, Equatable {
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
    
    init(
    createdAt : String? = nil,
    firstName : String? = nil,
    lastName : String? = nil,
    latitude : Double? = 0.00,
    longitude : Double? = 0.00,
    mapString : String? = nil,
     mediaURL : String? = nil,
    objectId : String? = nil ,
    uniqueKey : String? = nil,
    updatedAt : String? = nil
    )
    {
        
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
        
    }
}

