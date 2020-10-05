//
//  Test03ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test03ViewController: xViewController {
    
    @IBOutlet weak var redContainer: xContainerView!
    @IBOutlet weak var blueContainer: xContainerView!
    
    let page1 = xPageViewController.quickInstancetype()
    let page2 = xPageViewController.quickInstancetype()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func addChildren() {
        // MARK: - 默认样式
        self.xAddChild(self.page1, in: self.redContainer)
        var vcArr = [UIViewController]()
        let colorArr : [UIColor] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple]
        for i in 0 ..< colorArr.count {
            let vc = xViewController()
            vc.view.backgroundColor = colorArr[i]
            vcArr.append(vc)
        }
        self.page1.isOpenAutoChangeTimer = false 
        self.page1.reload(itemViewControllerArray: vcArr, change: {
            (page) in
            xLog("Page1 Change \(page)")
        }, click: {
            (page) in
            xLog("Page1 Click \(page)")
        })
        
        // MARK: - 自定义样式
        self.xAddChild(self.page2, in: self.blueContainer)
        var arr = ["/20200326/917dc35f83b5ae640fe8ac92dcb98d91.jpg",
                   "/20200327/b1d01b92988b82c017b12e81ba304f26.jpg",
                   "/20200326/5370a4388b35e84a7c5638d0312444cc.jpg",
                   "/20200326/85609037223c3d396d81a0a0b1bd6776.jpg",
                   "/20200327/1e847ba7c8ce669dfc712ba5b19a6618.jpg",
                   "/20200327/fa114ee13056f59e4bf3d364e90b1793.jpg"]
        arr = arr.map {
            (str) -> String in
            return "http://fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/uploads" + str
        }
        self.page2.isOpenAutoChangeTimer = true
        self.page2.reload(pictureArray: arr, change: {
            (page) in
            xLog("Page2 Change \(page)")
        }, click: {
            (page) in
            xLog("Page2 Click \(page)")
        })
    }
}
