//
//  extension.swift
//  onTheMap
//
//  Created by Asmahero on ٢٨ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//
import UIKit
import Foundation
extension UIViewController{
    
 func showAlertWithNoActionThenGO(message: String , withIdentifier: String!) {
        // the alert view
        let alert = UIAlertController(title: " ", message: message, preferredStyle: .actionSheet)
        self.present(alert,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: withIdentifier, sender: nil)
        })})
    }
 func showAlertWithNoActionThenDismiss(message: String) {
        // the alert view
        let alert = UIAlertController(title: " ", message: message, preferredStyle: .actionSheet)
        self.present(alert,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    
    func showingAlertMessageWithOneAction (messageTitle: String?, message: String? , ActionName: String?)
    {
        let requiredInfoAlert = UIAlertController (title: messageTitle, message: message, preferredStyle: .alert)
        requiredInfoAlert.addAction(UIAlertAction (title: ActionName, style: .default, handler: { _ in
            return
        }))
        self.present(requiredInfoAlert, animated: true, completion: nil)
        
    }
    func showingAlertMessageWithTwoActionsGoCancel(messageTitle: String?, message: String?)
    {
        let requiredInfoAlert = UIAlertController (title: messageTitle, message: message, preferredStyle: .alert)
        requiredInfoAlert.addAction(UIAlertAction (title: "Overwrite" , style: .destructive, handler: { _ in
            // let controller = VC.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            //  VC.navigationController!.pushViewController(controller, animated: true)
            self.performSegue(withIdentifier: "ADD", sender: nil)
            return
        }))
        requiredInfoAlert.addAction(UIAlertAction (title: "Cancel" , style: .default, handler: { _ in
            return
        }))
        self.present(requiredInfoAlert, animated: true, completion: nil)
        
    }
    
    // pass toOpen the string value
   func validateUrlAndOpen (urlString: String?)
    {
        let app = UIApplication.shared
        let urlString = urlString as String?
        if let urlString = urlString {
            // to make sure the url is not empty
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                if app.canOpenURL(url as URL) {
                    app.open(url as URL, options: [:], completionHandler: nil)
                    print ("succcess")
                } else {
                    showingAlertMessageWithOneAction(messageTitle: "Invalid URL", message: "Erorr with selected url which can not be opened or empty", ActionName: "OK")
                }
                
            }
        }
    }
    
    
}
