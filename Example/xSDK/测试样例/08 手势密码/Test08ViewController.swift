//
//  Test08ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test08ViewController: UIViewController {

    var gp = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 默认样式
    @IBAction func defaultBtnClick() {
        xGPasswordViewController.display(from: self) {
            [unowned self] (sender, gp) in
            if gp == self.gp {
                xMessageAlert.display(message: "密码相同")
                sender.dismiss()
            }
            xLog("手势密码：\(gp)")
            self.gp = gp
        }
    }
    
    // MARK: - 自定义样式
    @IBAction func freeBtnClick() {
        // 自定义样式
        let lineConfig = xGPasswordLineConfig()
        lineConfig.lineColor = .xNewRandom()
        
        let resultConfig = xGPasswordResultConfig()
        resultConfig.lineColor = .xNewRandom()
        resultConfig.pointColor = .xNewRandom()
        
        let pointConfig = xGPasswordPointConfig()
        pointConfig.interRadius = 15
        pointConfig.outerRadius = 25
        pointConfig.interFillNormalColor = .black
        pointConfig.interFillChooseColor = .xNewRandom()
        pointConfig.outerFillNormalColor = .groupTableViewBackground
        pointConfig.outerFillChooseColor = .clear
        pointConfig.outerStrokeNromalColor = .clear
        pointConfig.outerStrokeChooseColor = .xNewRandom()
        pointConfig.arrowColor = .xNewRandom()
        
        let config = xGPasswordConfig()
        config.lineConfig = lineConfig
        config.resultConfig = resultConfig
        config.pointConfig = pointConfig
        config.passwordMinLength = 3
        config.isAutoClearLine = true
        
        xGPasswordViewController.display(from: self, isShowCloseBtn: false, config: config) {
            [unowned self] (sender, gp) in
            if gp == self.gp {
                xMessageAlert.display(message: "密码相同")
                sender.dismiss()
            }
            xLog("手势密码：\(gp)")
            self.gp = gp
        }
    }
}
