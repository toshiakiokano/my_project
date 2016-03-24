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
    
    let sManager = SessionManager.sharedInstance
    var token = ""
    let ud = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorField.hidden = true

        
        sManager.getCSRFToken({ token in
            print(token)
            
            self.token = token
            self.confirmed_token()
        })
    }
    
    
    
    func confirmed_token() {
        if self.ud.objectForKey("confirm_token") != nil {
            let confirm_token = self.ud.objectForKey("confirm_token") as! String
            let email = self.ud.objectForKey("email") as! String
            
            
            let params = [
                "user": [
                    "email": email,
                    "confirmation_token": confirm_token
                ]
            ]
            
            let headers = [
                "X-CSRF-Token": self.token
            ]
            
            
            self.sManager.confirmToken(params, headers: headers, callback: { result in
                print("confirm")
                
                if result.result {
                    if self.errorField.text != "" {
                        self.errorField.text = ""
                        self.errorField.hidden = true
                    }
                    
                    
                } else {
                    self.errorField.hidden = false
                    self.errorField.text = result.errors
                }
                
                self.ud.removeObjectForKey("confirm_token")
            })
            
        }
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
            
            SessionManager.sharedInstance.login(params, label: errorField, headers: headers, callback: { result in
                
                if result.result {
                    if self.errorField.text != "" {
                        self.errorField.text = ""
                        self.errorField.hidden = true
                    }
                } else {
                    self.errorField.hidden = false
                    self.errorField.text = result.errors
                }
            })
        } else {
            return
        }
    }
}
