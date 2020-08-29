//
//  File.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/17/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate{
    func showAlert(title: String, message: String) {
             let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
             present(alertController, animated: true, completion: nil)
         }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    func setTextField(_ textField: UITextField){
               textField.text = ""
               textField.delegate = self
           }
          
   
}



extension API{
  enum Endpoints {
    private static let base = "https://onthemap-api.udacity.com/v1"
    case session
    case studentsLocations
    case studentInfo
    case poststudentLocation
    case signUp
    var stringVlaue: String{
            switch self {
            case .session: return Endpoints.base+"/session"
            case .studentsLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .studentInfo: return Endpoints.base + "/users/" + UserInfo.key!
            case .poststudentLocation: return Endpoints.base + "/StudentLocation"
            case .signUp: return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL{
            return URL(string: stringVlaue)!
        }
    }
}
