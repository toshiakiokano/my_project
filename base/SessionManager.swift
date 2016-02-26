//
//  SessionManager.swift
//  base
//
//  Created by toshi on 2015/12/17.
//  Copyright © 2015年 toshiaki. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SVProgressHUD
//import RealmSwift



class SessionManager {
    static let sharedInstance = SessionManager()
    
    

    
    
    func confirmToken(params: [String: Dictionary<String, String>], headers: [String: String], callback: (result: Bool, errors: String) -> Void) {
        SVProgressHUD.showWithStatus("読込中")
        
        Alamofire
            .request(.POST, "\(Const.domain)/api/v1/users/confirmations", parameters: params, headers: headers)
            .responseJSON { response in
                SVProgressHUD.dismiss()
                
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        // 読込中消す
                        SVProgressHUD.dismiss()
                        
                        if json["Errors"].isEmpty {
                            let msg = ""
                            SVProgressHUD.showWithStatus("完了")
                            
                            callback(result: true, errors: msg)
                        } else {
                            let msg = self.validations(json["Errors"])
                            SVProgressHUD.showWithStatus(msg)
                            
                            callback(result: false, errors: msg)
                        }
                    }

                } else if response.result.isFailure {
                    SVProgressHUD.showSuccessWithStatus("通信に失敗しました。")
                    print(response.result.value)
                    
                    callback(result: false, errors: "")
                } else {
                    return
                }
            }
        
    }
    
    

    ///////////////////////////////////////////////
    // MARK: get_csrf_token
    ///////////////////////////////////////////////
    func get_csrf_token(callback: (String) -> Void) {
        Alamofire
            .request(.POST, "\(Const.domain)/api/v1/token")
            .responseString { response in

                if response.result.isSuccess {
                    let token = response.result.value!
                    
                    callback(token)
                } else if response.result.isFailure {
                    print(response.result)
                } else {
                    return
                }
            }
    }
    
    
    ///////////////////////////////////////////////
    // MARK: Register
    ///////////////////////////////////////////////
    func register(params: [String: Dictionary<String, String>], headers: [String: String], target: UIViewController, callback: (result: Bool, errors: String) -> Void) {
        SVProgressHUD.show()
        
        Alamofire
            .request(.POST, "\(Const.domain)/api/v1/users/registrations", parameters: params, headers: headers)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        // 読込中消す
                        SVProgressHUD.dismiss()
                        
                        if json["Errors"].isEmpty {
                            let msg = ""

                            self.setUserData(json)
                            
                            callback(result: true, errors: msg)
                        } else {
                            let msg = self.validations(json["Errors"])

                            callback(result: false, errors: msg)
                        }
                    }
                } else if response.result.isFailure {
                    SVProgressHUD.showErrorWithStatus("通信に失敗しました。")
                    print(response.result.value)
                    
                    callback(result: false, errors: "")
                } else {
                    return
                }
            }
    }
    
    
    ///////////////////////////////////////////////
    // MARK: Login
    ///////////////////////////////////////////////
    func login(params: [String: Dictionary<String, String>], label: UILabel, headers: [String: String]) {
        SVProgressHUD.showWithStatus("読み込み中")
        
        Alamofire
            .request(.POST, "\(Const.domain)/api/v1/users/sign_in", parameters: params, headers: headers)
            .responseJSON { response in
                print(response.result)
                print(response.data)
                
                
                
        }
    }
    
    
    
    
    ///////////////////////////////////////////////
    //　MARK: functions
    ///////////////////////////////////////////////
    private let ud = NSUserDefaults.standardUserDefaults()
    
    
    // NSUserDefaults
    private func setUserData(obj: JSON) {
        //let ud = NSUserDefaults.standardUserDefaults()
        let email = obj["email"].string
        
        ud.setObject(email, forKey: "email")
        ud.synchronize()
    }
    
    func getUserData(callback: String -> Void) {
        var data: String
        
        //let ud = NSUserDefaults.standardUserDefaults()
        
        data = ud.objectForKey("email") as! String
        callback(data)
    }
    
    

    
    
    // validatetor
    private func validations(obj: JSON) -> String {
        var msgs: [String] = []
        
        if let items = obj.array {
            for item in items {
                if let error = item.string {
                    msgs.append(error)
                }
            }
        }
        
        let msg = msgs.joinWithSeparator("\n")
        return msg
    }
    
    

    
    

    

}