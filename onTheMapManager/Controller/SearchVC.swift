//
//  SearchVC.swift
//  onTheMap
//
//  Created by Asmahero on ١٦ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class SearchVC: UIViewController , MKMapViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var mapStringTextField: UITextField!
    
    @IBOutlet weak var mediaUrlTextField: UITextField!
    
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName : String!
    var mediaUrl : String!
    var CurrentUser: [UserProfile]!
    let submitVCSegue = "POSTL"
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldInitilize(mapStringTextField)
        textFieldInitilize(mediaUrlTextField)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        setFinding(false)
        subscribeToKeyboardNotifications()
        activityIndicator.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // to unsubscribe and back to normal situation
        unsubscribeFromKeyboardNotifications()
    }
    
    func setFinding(_ finding: Bool) {
        if finding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        self.mediaUrlTextField.isEnabled = !finding
        self.mapStringTextField.isEnabled = !finding
    }
    @IBAction func NextButton(_ sender: Any) {
        
        //To make sure the location name to search has no space by cutting spaces and also make sure is not empty
        guard let locationName = mapStringTextField.text?.trimmingCharacters(in: .whitespaces) , !locationName.isEmpty else{
            showingAlertMessageWithOneAction(messageTitle: "error location name", message: "make sure the location is not empty", ActionName: "ok")
            return
        }
        guard let mediaUrl = mediaUrlTextField.text?.trimmingCharacters(in: .whitespaces) , !mediaUrl.isEmpty else{
            showingAlertMessageWithOneAction(messageTitle: "error link", message: "make sure the link is not empty", ActionName: "ok")
            return
        }
        activityIndicator.isHidden = false
        self.setFinding(true)
        Students.getCoordinateFrom(locationName: locationName) { coordinate, error in
            if (error != nil)
            {
                self.activityIndicator.isHidden = true
                self.setFinding(false)
                 self.showingAlertMessageWithOneAction(messageTitle: "Incorrect Location Name", message: "Please check your location name", ActionName: "OK")
                return
            }
            self.locationCoordinate = coordinate
            self.locationName = locationName
            self.mediaUrl = mediaUrl
            let CurrentUser = UserProfile.init(
                objectId: "", uniquekey: "", sessionId: "", createdAt: "", first: "Asma", last: "Alkhaldi", mediaURL: mediaUrl, mapString: locationName, long: coordinate?.longitude, lat: coordinate?.latitude)
    
            self.performSegue(withIdentifier: self.submitVCSegue, sender: CurrentUser)
        }
    }
    //before we go to the next view controller we just send these values to the other view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == submitVCSegue
        {
            let vc = segue.destination as! SubmitVC
            vc.locationCoordinate = locationCoordinate
            vc.locationName = locationName
            vc.mediaURL =  mediaUrl
        }
    }
    @IBAction func cancel(_ sender: Any) {
       let _ = navigationController?.popToRootViewController(animated: true)
    
    }
    func textFieldInitilize (_ tf: UITextField)
    {
        // refer to delegate members
        self.mapStringTextField.delegate = self
        self.mediaUrlTextField.delegate = self
        tf.delegate = self
        tf.text = ""
    }
    
    // TO HAVE A RETURN TO DO ACTION WHEN I CLICK ON IT IN KEYBOARD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    // TO SHECK THE KEYBOARD NOT HIDING BEHIND AND BACK TO NORMAL WHEN DISMISS
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    var keyboardShown = false
    // to make sure the keyboard not cover the text field by moving it to the bottom of the field
    @objc  func keyboardWillShow(_ notification:Notification) {
        if (self.mediaUrlTextField.isEditing || self.mapStringTextField.isEditing) && !keyboardShown{
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardShown = true
        }
    }
    // back  the frame of keyboard to normal situation
    @objc func keyboardWillBeHide(note: Notification) {
        view.frame.origin.y = 0
        keyboardShown = false
    }
    //calling function when the keyboard will show or hide
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHide(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}




