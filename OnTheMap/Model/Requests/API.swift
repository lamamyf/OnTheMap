//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/11/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import Foundation
import UIKit
class API{
 
    class func logIn(username: String, password: String, completion: @escaping (String?) -> Void){
        let body = Udacity(udacity: SessionRequest(username: username, password:password))
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.httpBody = try JSONEncoder().encode(body)
        }catch{
            debugPrint(error)
            DispatchQueue.main.async {
                completion("Couldn't parse reequest body")
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode >= 200 && statusCode < 300{
                    do{
                        let range = 5..<data!.count
                        let newData = data?.subdata(in: range)
                        let responseObj = try JSONDecoder().decode(SessionResponse.self, from: newData!)
                        UserInfo.sessionID = responseObj.session.id
                        UserInfo.key = responseObj.account.key
                        self.getUserInfo(completion: { (error) in
                            if error != nil{
                                errorString = "Couldn't get student inforamtion"
                            }
                        })
                    }catch{
                        debugPrint(error)
                        errorString = "Couldn't parse response"
                    }
                    
                    
                    
                }else{
                    errorString = username == "" || password == "" ? "please fill in the username and password textfields" : "Provided login credintials didn't match our records"
                    print(statusCode)
                }
            }else{
                errorString = "No Internet Connection!"
                }
            DispatchQueue.main.async {
                completion(errorString)
            }
            
        }.resume()
    }

   class private func getUserInfo(completion: @escaping (Error?) -> Void){
        let url = Endpoints.studentInfo.url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{
                debugPrint(error)
                completion(error)
                return
            }
            
            do{
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObj = try JSONDecoder().decode(UserInfoResponse.self, from: newData)
                UserInfo.firstName = responseObj.firstName ?? ""
                UserInfo.lastName = responseObj.lastName ?? ""
                print(UserInfo.firstName! + " " + UserInfo.lastName!)
                 completion(nil)
            }catch{
                debugPrint(error)
                completion(error)
            }
        }.resume()
    }
    
    class func getStudentsLocations(completion: @escaping (String?) -> Void){
        let url = Endpoints.studentsLocations.url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var errorString: String?
             if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode >= 200 && statusCode < 300{
                    do{
                       let responseObj = try JSONDecoder().decode(Locations.self, from: data!)
                        StudentsLocationModel.locations = responseObj.results
                    }catch{
                        debugPrint(error)
                        errorString = "Couldn't parse response"
                    }
                }else{
                    errorString = "Couldn't populate locations"
                    print("Status Code: \(statusCode)")
                }
             }else{
                errorString = "Couldn't populate locations, check your internet connection "
            }
            
            DispatchQueue.main.async {
                completion(errorString)
            }
        }.resume()
    }
    
    class func postLocation(studentLocation: StudentLocation,completion: @escaping (String?) -> Void){
        var request = URLRequest(url: Endpoints.poststudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PostLoacationRequest(uniqueKey: studentLocation.uniqueKey!, firstName: studentLocation.firstName!, lastName: studentLocation.lastName!, mapString: studentLocation.mapString!, mediaURL: studentLocation.mediaURL!, latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
        
        do{
            request.httpBody = try JSONEncoder().encode(body)
        }catch{
            debugPrint(error)
            DispatchQueue.main.async {
                completion("Couldn't parse reequest body")
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
             var errorString: String?
             if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode < 200 || statusCode >= 300{
                    errorString = "Couldn't post location"
                    }
                       }else{
                           errorString = "Couldn't post location, check your internet connection!"
                       }
                       DispatchQueue.main.async {
                           completion(errorString)
                       }
        }.resume()
        
    }
    
    class func logOut(completion: @escaping (String?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var errorString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode < 200 || statusCode >= 300{
                    errorString = "Couldn't log out"
                }
            }else{
                errorString = "Couldn't log out, check your internet connection!"
            }
            DispatchQueue.main.async {
                completion(errorString)
            }
        }.resume()
    }

}

