//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/15/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController{

    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var mediaLink: UITextField!
    @IBOutlet weak var findLoactionBtn: UIButton!

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextField(address)
        setTextField(mediaLink)
    }
    
   
    private func setUI(_ isEnabled: Bool){
        if isEnabled{
            activityIndicatorView.startAnimating()
        }else{
            activityIndicatorView.stopAnimating()
        }
        
        address.isEnabled = !isEnabled
        mediaLink.isEnabled = !isEnabled
        findLoactionBtn.isEnabled = !isEnabled
       
    }

    @IBAction func findLoactionTapped(_ sender: Any) {
        guard let address = address.text, let mediaLink = mediaLink.text, address != "" , mediaLink != "" else {
            showAlert(title: "ERROR", message: "Please fill in the textfields!")
            return
        }
        
        setUI(true)
        gecode(address: address, mediaLink: mediaLink)
    }
    
    func gecode(address: String, mediaLink: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.setUI(false)
            guard let placemarks = placemarks, let location = placemarks.first?.location else{
                self.showAlert(title: "ERROR", message: "Unable to find location for \(address)")
                return
            }
            let coordinate = location.coordinate
         
            let studentLocation = StudentLocation(firstName:  UserInfo.firstName ?? "", lastName:  UserInfo.lastName ?? "", uniqueKey:  UserInfo.key ?? "", mapString: address, mediaURL: mediaLink, latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        
            self.performSegue(withIdentifier: "postLocationSegue", sender: studentLocation)
        }
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postLocationSegue"{
            let verifiyLocationVC = segue.destination as! VerifyLocationViewController
            verifiyLocationVC.location = (sender as! StudentLocation)
        }
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
