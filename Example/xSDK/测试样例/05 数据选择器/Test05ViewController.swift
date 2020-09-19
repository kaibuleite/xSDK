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
    
    var dataArray = [[String]]()
    let alertDataPicker = xDataPickerViewController.quickInstancetype()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化数据源
        let obj1 = ["周1", "周2", "周3", "周4", "周5", "周6", "周7"]
        let obj2 = ["早上", "中午", "下午"]
        let obj3 = ["家里", "学校", "公司", "商场"]
        self.dataArray = [obj1, obj2, obj3]
    }
    override func addChildren() {
        self.addChild(self.alertDataPicker, in: self.view)
    }
    
    // MARK: - 普通样式
    @IBAction func normalBtnClick() {
        // 每次重新加载数据都会重置样式
        self.alertDataPicker.reload(dataArray: self.dataArray)
        self.alertDataPicker.display(title: "选择任务", isSpring: true) {
            [unowned self] (list) in
            let name = list.joined(separator: "-")
            self.resultLbl.text = name
        }
    }
    
    // MARK: - 弹动可扩展
    @IBAction func springBtnClick() {
        self.alertDataPicker.display(title: "选择任务", isSpring: true) {
            [unowned self] (list) in
            let name = list.joined(separator: "-")
            self.resultLbl.text = name
        }
    }
}
