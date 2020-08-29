//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/11/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField(email)
        setTextField(password)
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        password.text = ""
        email.text = ""
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        setLoggingIn(true)
        API.logIn(username: email.text!, password: password.text!) { (error) in
            guard error == nil else{
                self.setLoggingIn(false)
                self.showAlert(title: "ERROR", message: error!)
                return
            }
            self.setLoggingIn(false)
            
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(API.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    private func setLoggingIn(_ loggingIn: Bool){
        if loggingIn{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        email.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        logInBtn.isEnabled = !loggingIn
        signUpBtn.isEnabled = !loggingIn
    }
    
     
}

