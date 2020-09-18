//
//  Kit04ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit04ViewController: UIViewController {
    
    @IBOutlet weak var nv1: xNavigationView!
    @IBOutlet weak var nv2: xNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置渐变色样式
        let colorArr = [UIColor.red.x_edit(alpha: 0.3),
                        UIColor.blue.x_edit(alpha: 0.3)]
        self.nv2.barColorView.setGradient(colors: colorArr)
        self.nv2.titleColor = .white
        self.nv2.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
