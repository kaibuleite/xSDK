//
//  Kit09ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit09ViewController: xViewController {
    
    @IBOutlet weak var code1View: xQRCodeImageView!
    @IBOutlet weak var code2View: xQRCodeImageView!
    @IBOutlet weak var code3View: xQRCodeImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func addKit() {
        self.code1View.set(code: "测试数据测试数据")
        let centerimage = UIColor.x_random(alpha: 0.8).x_toImage(size: .init(width: 30, height: 30))
        self.code2View.set(code: "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈", centerImage: centerimage)
        self.code3View.set(code: "啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊")
    }
}
