//
//  UserInfo.swift
//  onTheMap
//
//  Created by Asmahero on ١٨ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
struct UserProfile: Codable , Equatable {
    let objectId : String?
    let uniquekey : String?
    let sessionId : String?
   let createdAt :String?
    let first : String?
    let last :String?
    let mediaURL : String?
    let mapString : String?
    let  long : Double?
    let lat : Double?
    
    }


