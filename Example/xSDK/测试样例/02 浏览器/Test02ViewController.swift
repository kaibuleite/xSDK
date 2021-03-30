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
    
    @IBOutlet weak var urlInput: UITextField!
    
    @IBAction func goBtnClick() {
        let vc = xWebViewController.quickInstancetype()
        self.navigationController?.pushViewController(vc, animated: true)
        var str = self.urlInput.text ?? ""
        if str.isEmpty {
            str = self.urlInput.placeholder!
        }
        vc.load(url: str)
        /*
        let list = ["JS事件1", "JS事件2", "JS事件3", ]
        vc.addJavaScriptMethod(list: list)
        
        vc.addReceiveJavaScriptMethod {
            (name, msg) in
            xLog("js事件 ——— \(name)")
        }*/
    }
}
