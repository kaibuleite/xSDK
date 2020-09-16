//
//  Test02ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test02ViewController: UIViewController {
    
    @IBAction func noNaviBtnClick() {
        let vc = xWebViewController.quickInstancetype()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.load(url: "https://www.jianshu.com/p/747b7a1dfd06")
        vc.jsMgr.addReceiveWebJS {
            (name) in
            x_log("js事件 ——— \(name)")
        }
    }
}
