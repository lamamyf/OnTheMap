//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/12/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit

class TableViewController: ContainerViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.loadLocations()
        tableView.reloadData()
    }
   
    override func refresh(_ sender: Any){
        super.refresh(sender)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocationModel.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let studentLocation =  StudentsLocationModel.locations[indexPath.row]
        let firstName  = studentLocation.firstName ?? " "
        let lastName = studentLocation.lastName ?? " "
        cell.textLabel?.text =  firstName + " " + lastName
        cell.detailTextLabel?.text = studentLocation.mediaURL ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let toOpen = StudentsLocationModel.locations[indexPath.row].mediaURL
          if let toOpen = toOpen, let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url){
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }else{
              showAlert(title: "ERROR", message: "Failed to open \(toOpen ?? "URL")")
          }
    }

}


