//
//  SubmitVC.swift
//  onTheMap
//
//  Created by Asmahero on ١٦ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class SubmitVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName : String!
    var mediaURL : String!
    var CurrentUser: [UserProfile]!
    @IBOutlet weak var finish: ButtonStyle!
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        var annotations = [MKPointAnnotation] ()
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate!
        annotation.title = "Asma Alkaldi"
        annotation.subtitle = mediaURL!
        annotations.append(annotation)
        // print (locationCoordinate!)
        // HERE is the code to place the pin on the center of location coordinate, meters if increse it will be far and needed to be zoom
        let viewRegion = MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 200, longitudinalMeters: 200)
        self.MapView.addAnnotations(annotations)
        self.MapView.setRegion(viewRegion, animated: false)
    }
    
    // the shape of pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method to see what happend if you tap a pin
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                 self.validateUrlAndOpen(urlString: toOpen)
                
            }
        }
        
    }
    
    //MARK: calling function of moving to the second view when values are ready to store it
    @IBAction func finish(_ sender: Any) {
 
        ApiModel.postLocation(locationName, mediaURL, locationCoordinate){ (success, objectId ,createdAt, error) in
            // key represent the the unique key that declared in its dictionary at itsfunction  as key
            //TODO: Execute the entire code inside the completion body on the main thread asynchronous
            DispatchQueue.main.async {
                if error != nil {
                     self.showingAlertMessageWithOneAction(messageTitle: "Incorrect request", message: error?.localizedDescription, ActionName: "OK")
                    return
                }
                
                if !success {
                     self.showingAlertMessageWithOneAction(messageTitle: "Incorrect Location Name", message: "Please check your location name", ActionName: "OK")
                } else {
                    DispatchQueue.main.async {
                        //Here is a kind of method of UserDefaults to save the values that posted by the user and to make sure the user has post a location before
                        // to make the image of cell is memed image
                        UserDefaults.standard.set(objectId, forKey: "objectId")
                        self.dismiss(animated: true, completion: nil);                  self.showAlertWithNoActionThenDismiss(message: "You are successfully posted a location")
                      
                    }
                    
                    
                }
                
            }
            
        }
    }
    
    
}
