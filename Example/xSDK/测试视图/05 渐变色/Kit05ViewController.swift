//
//  Kit05ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit05ViewController: UIViewController {
    
    @IBOutlet weak var gc1View: xGradientColorView!
    @IBOutlet weak var gc2View: xGradientColorView!
    @IBOutlet weak var gc3View: xGradientColorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var colorArr1 = [UIColor]()
        var colorArr2 = colorArr1
        var colorArr3 = colorArr1
        // 设置样式
        // MARK: - 渐变色1——默认
        colorArr1 = [.red, .blue]
        self.gc1View.setGradient(colors: colorArr1,
                                 startPoint: .init(x: 0, y: 0.5),
                                 endPoint: .init(x: 1, y: 0.5))
        
        // MARK: - 渐变色2——中间隔断
        colorArr2 = [.gray, .orange]
        self.gc2View.setGradient(colors: colorArr2,
                                 startPoint: .init(x: 0, y: 0.5),
                                 endPoint: .init(x: 1, y: 0.5),
                                 locations: [0.5, 0.5])
        
        // MARK: - 渐变色3——多种颜色
        colorArr3 = [.red, .orange, .yellow, .gray, .brown, .blue, .purple]
        self.gc3View.setGradient(colors: colorArr3,
                                 startPoint: .init(x: 0, y: 0),
                                 endPoint: .init(x: 1, y: 1))
    }

}
