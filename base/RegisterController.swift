//
//  RegistController.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import UIKit




class RegisterController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var errorField: UILabel!
   
    var token = ""
    
    
    let sManager = SessionManager.sharedInstance
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tokenを取得　フォームを送る際にこのtokenをつかってサーバに投げる
        sManager.get_csrf_token { token in
            print(token)
            
            self.token = token
        }
        
        errorField.hidden = true
    }
    
    
    
    
    // register action button
    @IBAction func pressedRegisterButton(sender: AnyObject) {
        if ((emailField.text! != "") && (passwordConfirmField.text! != "")) {
            let email = emailField.text!
            let password = passwordField.text!
            let confirm = passwordConfirmField.text!
            
            let params = [
                "user": [
                    "email": email,
                    "password": password,
                    "password_confirmation": confirm
                ]
            ]
            
            let headers = [
                "X-CSRF-Token": self.token
            ]
            
            
            sManager.register(params, headers: headers, callback: { result in
                if result.result {
                    if self.errorField.text != "" {
                        self.errorField.text = ""
                        self.errorField.hidden = true
                    }
                    
                    // NSUserDefaults
                    self.sManager.getUserData { result in
                        let result = result
                        
                        print(result)
                        
                        let params = [
                            "user": [
                                "email": result,
                                
                            ]
                        ]
                        let headers = [
                            "X-CSRF-Token": ""
                        ]
                        
                        self.sManager.alert(self)
                        
                    }
                    
                    // realm
//                    self.sManager.getUserObjectData({ result in
//                        let result = result
//                        
//                        self.sManager.alert(self)
//                    })
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
