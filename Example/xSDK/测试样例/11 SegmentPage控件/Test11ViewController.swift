//
//  Test11ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test11ViewController: xViewController {

    let sp = xSegmentPageViewController.quickInstancetype()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addChildren() {
        self.xAddChild(self.sp, in: self.childContainer)
        // 加载数据
        let titleArr = ["红色", "橙色", "黄色", "绿色", "青色", "蓝色", "紫色"]
        let colorArr : [UIColor] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple]
        var vcArr = [UIViewController]()
        for color in colorArr {
            let vc = UIViewController.init()
            vc.view.backgroundColor = color
            vcArr.append(vc)
        }
        DispatchQueue.main.async {
        }
        self.sp.reload(segmentDataArray: titleArr,
                       segmentItemFillMode: .fillEqually,
                       pageDataArray: vcArr)
    }
}
