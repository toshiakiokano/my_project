//
//  RegistController.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import UIKit
import SVProgressHUD



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
        sManager.getCSRFToken { token in
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
            
            
            sManager.register(params, headers: headers, target: self, callback: { result in
                if result.result {
                    if self.errorField.text != "" {
                        self.errorField.text = ""
                        self.errorField.hidden = true
                    }
                    self.alert()
                } else {
                    self.errorField.hidden = false
                    self.errorField.text = result.errors
                }
            })
        } else {
            return
        }
    }
    
    // alert
    private func alert() {
        let alert = UIAlertController(title: "仮登録が完了しました", message: "メールから本登録をお済ませください。", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    


    
    
}
