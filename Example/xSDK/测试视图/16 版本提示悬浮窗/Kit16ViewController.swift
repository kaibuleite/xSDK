//
//  Kit16ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/27.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit16ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let des = "Build \(xAppManager.appBuildVersion)"
        xVersionDebugView.show(des: des)
    }

}
