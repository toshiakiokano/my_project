//
//  ModuleManager.swift
//  base
//
//  Created by toshi on 2016/02/17.
//  Copyright © 2016年 toshiaki. All rights reserved.
//
// いらないかも
import SVProgressHUD

class ModuleManager {
    static let sharedInstance = ModuleManager()
    
    
    // 20160220時点　使ってない
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
}
