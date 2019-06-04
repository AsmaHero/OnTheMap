//
//  ListVC.swift
//  onTheMap
//
//  Created by Asmahero on ١٦ رمضان، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import Foundation
import UIKit

class ListVC: UIViewController{
    // MARK: Properties
   var student: [StudentsLocation]!
      var selectedIndex = 0
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var update: UIBarButtonItem!
    
    @IBOutlet weak var addPin: UIBarButtonItem!

    @IBOutlet weak var Logout: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiModel.getStudentsLocation() { students, error in
            //assign [StudentsLocation] values from the data of request
            Students.studentsArray = students ?? []
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBAction func Add(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "objectId") != nil {
            showingAlertMessageWithTwoActionsGoCancel(messageTitle: "overwrite", message: "Do you want to overwrite?")
        }
        else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func UPDATE(_ sender: Any) {
        self.tableView.reloadData()
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

extension ListVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell")!
        let student =  Students.studentsArray[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? " ")" + " \(student.lastName ?? " ")"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? " ")"
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open url
        let toOpen =  Students.studentsArray[indexPath.row].mediaURL!
        validateUrlAndOpen(urlString: toOpen)
        }
}

