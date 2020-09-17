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
    
    @IBOutlet weak var redContainer: xClearView!
    @IBOutlet weak var yellowContainer: xClearView!
    @IBOutlet weak var greenContainer: xClearView!
    
    let seg1 = xSegmentViewController.quickInstancetype()
    let seg2 = xSegmentViewController.quickInstancetype()
    let seg3 = xSegmentViewController.quickInstancetype()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addSegment1()
        self.addSegment2()
        self.addSegment3()
    }
    
    /// 菜单1
    public func addSegment1()
    {
        let config = xSegmentConfig()
        config.itemSelectedTitleColor = .red
        self.seg1.config = config
        let arr = ["苹果", "香蕉", "梨子", "芒果", "葡萄"]
        self.seg1.reload(titleArray: arr, fontSize: 10) {
            (idx) in
            x_log(arr[idx])
        }
        self.addChild(self.seg1, in: self.redContainer)
    }
    
    /// 菜单2
    public func addSegment2()
    {
        
    }
    
    /// 菜单3
    public func addSegment3()
    {
        
    }
}
