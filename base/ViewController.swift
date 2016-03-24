//
//  ViewController.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    let sManager = SessionManager.sharedInstance
    var token = ""
    let ud = NSUserDefaults.standardUserDefaults()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

