//
//  Test05ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test05ViewController: xViewController {
    
    @IBOutlet weak var resultLbl: UILabel!
    
    var dataArray = [[xDataPickerModel]]()
    let alertDataPicker = xDataPickerViewController.quickInstancetype()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化数据源
        let obj1 = xDataPickerModel.newList(array: ["周1", "周2", "周3", "周4", "周5", "周6", "周7"])
        let obj2 = xDataPickerModel.newList(array: ["早上", "中午", "下午"])
        let obj3 = xDataPickerModel.newList(array: ["家里", "学校", "公司", "商场"])
        
        self.dataArray = [obj1, obj2, obj3]
    }
    override func addChildren() {
        self.xAddChild(self.alertDataPicker, in: self.view)
        self.alertDataPicker.reload(dataArray: self.dataArray)
    }
    
    // MARK: - 不保存状态
    @IBAction func nosaveBtnClick() {
        // 每次重新加载数据都会重置样式
        self.alertDataPicker.reload(dataArray: self.dataArray)
        self.alertDataPicker.display(title: "选择任务", isSpring: true) {
            [unowned self] (list) in
            var name = ""
            list.forEach {
                (model) in
                name += model.name
            }
            self.resultLbl.text = name
        }
    }
    
    // MARK: - 保存状态
    @IBAction func saveBtnClick() {
        self.alertDataPicker.display(title: "选择任务", isSpring: true) {
            [unowned self] (list) in
            var name = ""
            list.forEach {
                (model) in
                name += model.name
            }
            self.resultLbl.text = name
        }
    }
}
