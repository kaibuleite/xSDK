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
        let vc = xGPasswordViewController.quickInstancetype() 
        vc.addInputCompleted {
            [unowned self] (gp) in
            if gp.isEmpty == false {
                if gp == self.gp {
                    vc.dismiss(animated: true, completion: nil)
                    xMessageAlert.display(message: "密码相同")
                }
            }
            self.gp = gp
            xLog("手势密码：\(gp)")
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - 自定义样式
    @IBAction func freeBtnClick() {
        let vc = xGPasswordViewController.quickInstancetype()
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
        
        vc.lineConfig = lineConfig
        vc.resultConfig = resultConfig
        vc.pointConfig = pointConfig
        vc.passwordMinLength = 3
        
        vc.addInputCompleted {
            [unowned self] (gp) in
            if gp.isEmpty == false {
                if gp == self.gp {
                    xMessageAlert.display(message: "密码相同")
                    vc.dismiss(animated: true, completion: nil)
                }
            }
            self.gp = gp
            vc.clearAll()
            xLog("手势密码：\(gp)")
        }
        self.present(vc, animated: true, completion: nil)
    }
}
