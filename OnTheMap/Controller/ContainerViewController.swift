//
//  ContainerViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/12/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadLocations(){
        API.getStudentsLocations { errorString in
            guard errorString == nil else{
                self.showAlert(title: "ERROR", message: errorString!)
                return
            }
            guard StudentsLocationModel.locations.count > 0 else {
                self.showAlert(title: "Error", message: "No pins found")
                return
            }
            
        }
    }
    
 
    @IBAction func refresh(_ sender: Any){
       loadLocations()
    }
    
    @IBAction func LogOut(_ sender: Any){
        API.logOut { (errorString) in
            guard errorString == nil else{
                self.showAlert(title: "ERROR", message: errorString!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    

   
}

