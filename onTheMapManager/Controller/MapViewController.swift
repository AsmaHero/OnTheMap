//
//  MapViewController.swift
//  TheMovieManager
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    //MARK: OUTLETS
  
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var addPin: UIBarButtonItem!
    @IBOutlet weak var update: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
          var annotations = [MKPointAnnotation] ()
        ApiModel.getStudentsLocation () {(StudentsLocation, error) in
            DispatchQueue.main.async {
                if error != nil {
                     self.showingAlertMessageWithOneAction(messageTitle: "Erorr performing request", message: error?.localizedDescription, ActionName: "OK")
                    return
                }
                
                
                //annotation is info icon
                // To make sure  StudentsLocation has arrays or values
                guard let locationsArray = StudentsLocation else {
                    self.showingAlertMessageWithOneAction(messageTitle: "Erorr loading locations", message: "There was an error loading locations", ActionName: "OK")
                    return
                }

                // Loop on all the values of StudentsLocation
                for locationStruct in locationsArray {
                //TODO: Get all the values in the array, if it's nil its value should be " ", for that use Nil-Coalescing Operator (??)
                    let long = CLLocationDegrees (locationStruct.longitude ?? 0)
                    let lat = CLLocationDegrees (locationStruct.latitude ?? 0)
                    let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    let mediaURL = locationStruct.mediaURL ?? " "
                    let first = locationStruct.firstName ?? " "
                    let last = locationStruct.lastName ?? " "
                    // Here we create the annotation and set its coordiate, title, and subtitle properties, annotation is that info. icon when we click on the pin
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append (annotation)
                }
                //add that annotations in the mapview
                self.MapView.addAnnotations (annotations)
            }
        }//end getAllLocations
    }
    // here is to identify the shape of your pin, how it looks like
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
    
    // This delegate method is implemented to respond to taps on annotation icon
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // here if we click on the pin (i)what happend
        if control == view.rightCalloutAccessoryView {
            //Here to check the string of annotation.subtitle, to do something with it if we click
            if let toOpen = view.annotation?.subtitle! {
                validateUrlAndOpen(urlString: toOpen)
                
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        //     Students.userhasData = false
        // Students.userhasData = true
        if UserDefaults.standard.string(forKey: "objectId") != nil {
            
            showingAlertMessageWithTwoActionsGoCancel(messageTitle: "overwrite", message: "Do you want to overwrite?")
        } else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    @IBAction func update(_ sender: Any) {
        self.MapView.reloadInputViews()
        self.MapView.updateFocusIfNeeded()
    }
    
    @IBAction func logout(_ sender: Any) {
        ApiModel.deleteSession{ error in
            //TODO: Execute the entire code inside the completion body on the main thread asynchronous
            if (error != nil)
            {
                DispatchQueue.main.async {
                     self.showingAlertMessageWithOneAction(messageTitle:  "Erorr performing request", message: error?.localizedDescription, ActionName: "OK")
                    return
                }
            }
        }
      showAlertWithNoActionThenDismiss(message: "You are successfully loggin out")
        self.dismiss(animated: true, completion: nil)
    }
}



