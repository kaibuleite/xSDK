//
//  Test06ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test06ViewController: xViewController {
    
    @IBOutlet weak var resultLbl: UILabel!
    
    let alertDataPicker = xDataPickerViewController.quickInstancetype()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func addChildren() {
        self.addChild(self.alertDataPicker, in: self.view)
    }
    
    // MARK: - 普通样式
    @IBAction func normalBtnClick() {
    }
    
    // MARK: - 弹动可扩展
    @IBAction func springBtnClick() {
        let obj1 = xMutableDataPickerModel.init(name: "数据0")
        obj1.childList = self.randomArray(count: 3, prefix: "甜点")
        let obj2 = xMutableDataPickerModel.init(name: "数据1")
        obj2.childList = self.randomArray(count: 4, prefix: "水果")
        let obj3 = xMutableDataPickerModel.init(name: "数据2")
        obj3.childList = self.randomArray(count: 6, prefix: "蔬菜")
    }
    
    /// 创建随机数组
    public func randomArray(count : Int, prefix : String) -> [xMutableDataPickerModel]
    {
        var ret = [xMutableDataPickerModel]()
        for i in 0 ..< count {
            let str = "\(prefix):\(i)"
            let model = xMutableDataPickerModel.init(name: str)
            ret.append(model)
        }
        return ret
    }

}
