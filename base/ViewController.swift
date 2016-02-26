//
//  ViewController.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sManager = SessionManager.sharedInstance
    var token = ""
    let ud = NSUserDefaults.standardUserDefaults()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if ud.boolForKey("confirm_token") {
            // tokenを取得　フォームを送る際にこのtokenをつかってサーバに投げる
            sManager.get_csrf_token { token in
                print(token)
                
                self.token = token
            }

            
            
            let confirm_token = ud.objectForKey("confirm_token") as! String
            let email = ud.objectForKey("email") as! String
            
            
            let params = [
                "user": [
                    "email": email,
                    "confirmation_token": confirm_token
                ]
            ]
            
            let headers = [
                "X-CSRF-Token": self.token
            ]
            
            
            sManager.confirmToken(params, headers: headers, callback: { result in
                if result.result {
                    self.ud.removeObjectForKey("confirm_token")
                }
            })
            
            
        } else {
            print("Not confirm_token")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

