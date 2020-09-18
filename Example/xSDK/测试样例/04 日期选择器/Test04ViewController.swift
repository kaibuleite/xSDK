//
//  Test04ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test04ViewController: xViewController {

    @IBOutlet weak var resultLbl: UILabel!
    
    let alertDatePicker = xDatePickerViewController.quickInstancetype()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func addChildren() {
        self.addChild(self.alertDatePicker, in: self.view)
    }
    
    // MARK: - 普通样式
    @IBAction func normalBtnClick() {
        let config = xDatePickerConfig()
        config.maxDate = Date()
        config.model = .dateAndTime
        self.alertDatePicker.update(config: config)
        self.alertDatePicker.display(title: "选择日期", isSpring: false) {
            [unowned self] (timeStamp) in
            // 返回时间戳,毫秒级,带小数
            x_log(timeStamp)
            self.resultLbl.text = "\(timeStamp)".x_toDateString(format: "yyyy-MM-dd hh:mm:ss")
        }
    }
    
    // MARK: - 弹动
    @IBAction func springBtnClick() {
        let config = xDatePickerConfig()
        config.minDate = Date()
        config.model = .dateAndTime
        self.alertDatePicker.update(config: config)
        self.alertDatePicker.display(title: "选择日期", isSpring: true) {
            [unowned self] (timeStamp) in
            x_log(timeStamp)
            self.resultLbl.text = "\(timeStamp)".x_toDateString(format: "yyyy年MM月dd日 hh时mm分ss秒")
        }
    }

}
