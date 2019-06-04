//
//  MovieModel.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//
import CoreLocation
import Foundation
class ApiModel {
    static var UK : String?
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        case login
        case getStudentslocation
        case postLocation
        case deleteSession
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .getStudentslocation: return Endpoints.base + "/StudentLocation" + "?limit=100" + "&order=-updatedAt"
            case .postLocation : return Endpoints.base + "/StudentLocation"
            case .deleteSession : return Endpoints.base + "/Session"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //response will be the login right or wrong and give u additional data that you might need it which is a string that hold key represent as uinquekey
    static func login (_ username : String!, _ password : String!, completion: @escaping (Bool, String, Error?)-> ()) {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false, "", error)
                return
            }
            
            //Get the status code to check if the response is OK or not
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed (you need to call return in let guard's else body anyway)
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, "", statusCodeError)
                return
            }
            
            
            if statusCode >= 200  && statusCode < 300 {
                // to verify that
                //Skipping the first 5 items in the array and then go from 5th item to the end. that related to only api udacity, not all api to get the required request.
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                
                //Print the data to see it and know you'll parse it (this can be removed after you complete building the app)
                print (String(data: newData!, encoding: .utf8)!)
                
                //TODO: Get an object based on the received data in JSON format
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                
                //TODO: Convert the object to a dictionary and call it loginDictionary
                let loginDictionary = loginJsonObject as? [String : Any]
                // get from the response , the dictionary of account inside udacity dictionary that take username and password. he will give you one information that related to you only and identify you. "key" is the key value of account dictionary that hold unique value.
                //Get the unique key of the user if the account is true
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                let uniqueKey = accountDictionary? ["key"] as? String ?? " "
                UK = uniqueKey
                completion (true, uniqueKey, nil)
            } else {
                // Add a Switch on httpStatusCode and return appropriate error
                // Status Code to check
                // 400: BadRequest
                // 401: Invalid Credentials
                // 403: Unauthorized
                // 405: HttpMethod Not Allowed
                // 410: URL Changed
                // 500: Server Error
                var message = "UnknownError"
                switch statusCode{
                case 400:
                    message = "BadRequest"
                    break;
                case 401:
                    message = "Unauthenticated"
                    break;
                case 403 :
                    message = "Unauthorized"
                    break;
                case 404 :
                    message = "ResourceNotFound"
                    break;
                case 405 :
                    message = "HTTPMethodNotAllowed"
                    break;
                case 410 :
                    message = "URLChanged"
                    break;
                case 500 :
                    message = "ServerError"
                    break;
                default:
                    message = "UnknownError"
                }
                
                let userInfo = [NSLocalizedDescriptionKey: message]
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: userInfo)
                completion(false,"", statusCodeError)
               
            }
        }
        //Start the task
        task.resume()
    }
    
    
    class func getStudentsLocation (completion: @escaping ([StudentsLocation]?, Error?) -> Void) {
        var request = URLRequest (url: Endpoints.getStudentslocation.url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            //Print the data to see it and know you'll parse it
        //    print (String(data: data!, encoding: .utf8)!)
            // see the response of request to see if succcess or not
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed (you need to call return in let guard's else body anyway)
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                //Get an object based on the received data in JSON format
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                
                //TODO: Convert jsonObject data to a dictionary
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                //TODO: get the locations (associated with the key “results") and store it into a constant named resultArray
                let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                
                //Check if the result array is nil using guard let, if it's return, otherwise continue
                guard let array = resultsArray else {return}
                
                //TODO: Convert the array above into a valid JSON Data object (so you can use that object to decode it into an array of student locations) and name it dataObject
                let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                
                //Use JSONDecoder to convert dataObject to an array of structs and ordered all arrays rows to that struct
                let studentsLocations = try! JSONDecoder().decode([StudentsLocation].self, from: dataObject)
                completion (studentsLocations, nil)
            }
            else{
                var message = "UnknownError"
                switch statusCode{
                case 400:
                    message = "BadRequest"
                    break;
                case 401:
                    message = "Unauthenticated"
                    break;
                case 403 :
                    message = "Unauthorized"
                    break;
                case 404 :
                    message = "ResourceNotFound"
                    break;
                case 405 :
                    message = "HTTPMethodNotAllowed"
                    break;
                case 410 :
                    message = "URLChanged"
                    break;
                case 500 :
                    message = "ServerError"
                    break;
                default:
                    message = "UnknownError"
                }
                
                let userInfo = [NSLocalizedDescriptionKey: message]
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: userInfo)
                completion([], statusCodeError)
        }
        
    }
        task.resume()
    }
    class func deleteSession ( completion: @escaping (Error?)-> ()) {
        var request = URLRequest(url:Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error…
                completion(error)
                return
            }
        //    let range = Range(5..<data!.count)
       //     let newData = data?.subdata(in: range) /* subset response data! */
  //          print(String(data: newData!, encoding: .utf8)!) THIS IS ONLY IF I WANT THE VALUE OF newData RESPONSE TO UTILIZE IN FUTURE
            completion(nil)
            
        }
        task.resume()
    }
    
    class func postLocation (_ mapString: String!, _ mediaURL: String!, _ coor: CLLocationCoordinate2D!, completion: @escaping (Bool, String, String,  Error?)-> ()) {
        var request = URLRequest(url: Endpoints.postLocation.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: Convert the array above into a valid JSON Data object (so you can use that object to decode it into an array of student locations) and name it dataObject
        request.httpBody = "{\"uniqueKey\": \"1111\", \"firstName\": \"ASMA\", \"lastName\": \"ALKHALDI\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(coor.latitude), \"longitude\": \(coor.longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed
                // if error exisdt
                completion (false, "","" ,error)
                return
            }
            //Get the status code to check if the response is OK or not
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed (you need to call return in let guard's else body anyway)
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (false, "", "", statusCodeError)
                return
            }
            
            
            
            if statusCode >= 200  && statusCode < 300 {
 //******** Note: this is for me for future uses only (objectId, createdAt), these are not utilized yet in my project***************//////////
                //    print (String(data: data!, encoding: .utf8)!)
                // data will presented in strange format that can not be read easily
                //TODO: Get an object based on the received data in JSON format
                print(String(data: data!, encoding: .utf8)!)
                let resultsJsonObject = try! JSONSerialization.jsonObject(with: data!, options: [])
                //TODO: Convert the object to a dictionary and call it loginDictionary
                let resultsDictionary = resultsJsonObject as? [String : Any]
                // resultd data from dictionary
                let resultsData = resultsDictionary?[""] as? [String : Any]
                let objectId = resultsData? ["objectId"] as? String ?? " "
                let createdAt = resultsData? ["createdAt"] as? String ?? " "
                completion (true, objectId, createdAt,  nil)
            } else {
                var message = "UnknownError"
                switch statusCode{
                case 400:
                    message = "BadRequest"
                    break;
                case 401:
                    message = "Unauthenticated"
                    break;
                case 403 :
                    message = "Unauthorized"
                    break;
                case 404 :
                    message = "ResourceNotFound"
                    break;
                case 405 :
                    message = "HTTPMethodNotAllowed"
                    break;
                case 410 :
                    message = "URLChanged"
                    break;
                case 500 :
                    message = "ServerError"
                    break;
                default:
                    message = "UnknownError"
                }
                
                let userInfo = [NSLocalizedDescriptionKey: message]
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: userInfo)
                completion(false, "", "", statusCodeError)
            }
        }
        task.resume()
    }
}
