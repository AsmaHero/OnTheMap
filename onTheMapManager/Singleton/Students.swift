//
//  Students.swift
//  onTheMap
//
//  Created by Asmahero on ١٧ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//Singleton class to take alll the variables 

import Foundation
import UIKit
import CoreLocation

class Students {
    // these static variables acting as global variables using 1st statement
    static let shared = Students()
   
    static var studentsArray = [StudentsLocation]()
    static var usersArray = [UserProfile]()
    
    // these static functions can be used for the app functions
    //NOTE: Passing VIEW CONTROLLER IS NOT A GOOD PRACTICE BUT HERE WE PUT IT TO AVOID REPRTETION WHEN USING EXTENSIONS FOR EVERY VIEW CONTROLLER THAT ALL NEED THE SAME METHODS
   
    static func getCoordinateFrom (locationName: String,completion: @escaping(_ coordinate: CLLocationCoordinate2D? , _ error: Error?) -> ())
    {
        CLGeocoder().geocodeAddressString(locationName) { location, error in
            let coordinate = (location?.first?.location?.coordinate)
            completion(coordinate , error)
        }
    }
    /**** NOTE : These functions were not used in my project but may I needed for future uses
    static func PrintCountries(){
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            //print(name)
        }
    }
    
    static func ContainsString(stringname: String? , keyword: String!) -> Bool{
        if  stringname!.range(of: keyword, options: .caseInsensitive) != nil {
            return true
        }
        else{
            return false
        }
    }
 */
}

