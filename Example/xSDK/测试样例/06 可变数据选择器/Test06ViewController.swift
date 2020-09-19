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
    var dataArray = [xMutableDataPickerModel]()
    
    let alertDataPicker = xMutableDataPickerViewController.quickInstancetype()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化数据源
        let obj1 = xMutableDataPickerModel.init(name: "水果")
        obj1.childList = xMutableDataPickerModel.newList(array: ["苹果", "梨", "其他"])
        obj1.childList[0].childList = xMutableDataPickerModel.newList(array: ["🍏", "🍎"])
        obj1.childList[1].childList = xMutableDataPickerModel.newList(array: ["🍐", "🍍"])
        obj1.childList[2].childList = xMutableDataPickerModel.newList(array: ["🍒", "🍇", "🍓", "🥝"])
        
        let obj2 = xMutableDataPickerModel.init(name: "蔬菜")
        obj2.childList = xMutableDataPickerModel.newList(array: ["绿叶菜类", "根菜类", "瓜类", "茄果类"])
        obj2.childList[0].childList = xMutableDataPickerModel.newList(array: ["🥬", "🥦", "🌽"])
        obj2.childList[1].childList = xMutableDataPickerModel.newList(array: ["🥕", "🍠", "🥜"])
        obj2.childList[2].childList = xMutableDataPickerModel.newList(array: ["🍉", "🥒"])
        obj2.childList[3].childList = xMutableDataPickerModel.newList(array: ["🍆"])
        
        let obj3 = xMutableDataPickerModel.init(name: "美食")
        obj3.childList = xMutableDataPickerModel.newList(array: ["中餐", "日料", "西餐"])
        obj3.childList[0].childList = xMutableDataPickerModel.newList(array: ["🍗", "🍖", "🍤", "🍳"])
        obj3.childList[1].childList = xMutableDataPickerModel.newList(array: ["🍙", "🍥", "🍣", "🍡"])
        obj3.childList[2].childList = xMutableDataPickerModel.newList(array: ["🍔", "🍟", "🥗", "🍰", "🌮"])
        
        self.dataArray = [obj1, obj2, obj3]
    }
    override func addChildren() {
        self.addChild(self.alertDataPicker, in: self.view)
        self.alertDataPicker.reload(dataArray: self.dataArray)
    }
    
    // MARK: - 不保存状态
    @IBAction func nosaveBtnClick() {
        self.alertDataPicker.reload(dataArray: self.dataArray)
        self.alertDataPicker.display(title: "选择商品") {
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
        self.alertDataPicker.display(title: "选择商品") {
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
