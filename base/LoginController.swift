//
//  LoginController.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionManager.sharedInstance.get_csrf_token({ token in
            print(token)
            
            self.token = token
        })
        
        errorField.hidden = true
    }
    
    @IBAction func pressedLoginButton(sender: AnyObject) {
        if ((emailField.text! != "") && (passwordField.text! != "")) {
            let email = emailField.text!
            let password = passwordField.text!
            
            let params = [
                "user": [
                    "email": email,
                    "password": password
                ]
            ]
            
            let headers = [
                "X_CSRF_Token": self.token
            ]
            
            SessionManager.sharedInstance.login(params, label: errorField, headers: headers)
        } else {
            return
        }
    }
}
