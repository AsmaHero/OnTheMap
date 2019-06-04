//
//  File.swift
//  onTheMap
//
//  Created by Asmahero on ١٦ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //  @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
textFieldInitilize (emailTextField)
textFieldInitilize (passwordTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLoggingIn(false)
        subscribeToKeyboardNotifications()
        activityIndicator.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // to unsubscribe and back to normal situation
        unsubscribeFromKeyboardNotifications()
    }

    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.loginButton.isEnabled = !loggingIn
    }
    @IBAction func loginClicked(_ sender: Any) {
        
        let password = passwordTextField.text
        guard let username = emailTextField.text?.trimmingCharacters(in: .whitespaces) , !username.isEmpty else{
            showingAlertMessageWithOneAction(messageTitle: "error location name", message: "make sure the location is not empty", ActionName: "ok")
            return
        }
        if (username.isEmpty) || (password!.isEmpty) {
            
            showingAlertMessageWithOneAction(messageTitle: "Fill the required fields", message: "Please fill both the email and password", ActionName: "OK")
            
        } else {
            
            ApiModel.login(username, password){(success, key, error) in
                DispatchQueue.main.async {
                    if (error != nil) {
                        //Generall error with network
                       self.showingAlertMessageWithOneAction(messageTitle:  "Erorr performing request", message: error?.localizedDescription, ActionName: "OK")
                        return
                    }
                    if !success {
                        // error with login information
                         self.showingAlertMessageWithOneAction(messageTitle:  "Erorr logging in", message: "incorrect email or password", ActionName: "OK")
                    } else {
                        self.activityIndicator.isHidden = false
                        self.setLoggingIn(true)
                         self.showAlertWithNoActionThenGO(message: "You are successfully loggin in", withIdentifier: "completeLogin")
                        ApiModel.UK = key //generateduk
                     
                        // print ("the key is \(key)")
                    }
                }}
        }
    }
    func textFieldInitilize (_ tf: UITextField)
    {
 
        // refer to delegate members
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        tf.delegate = self
        tf.text = ""
    }

    // When a user presses return, the keyboard should be dismissed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }    // TO SHECK THE KEYBOARD NOT HIDING BEHIND AND BACK TO NORMAL WHEN DISMISS
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    var keyboardShown = false
    // to make sure the keyboard not cover the text field by moving it to the bottom of the field
    @objc  func keyboardWillShow(_ notification:Notification) {
        if (self.emailTextField.isEditing || self.passwordTextField.isEditing) && !keyboardShown{
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
