//
//  xAppManager.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

class xAppManager: NSObject {

    /// 单例
    static let shared = xAppManager()
    private override init() { }
    

    /// 是否打印控制台信息
    var isLog = true
    /// 是否是测试环境
    var isDebug = true
    
    /// 主题色
    var themeColor = UIColor.hex("#487FFC")
    /// TableView背景色
    var tableViewBackgroundColor = UIColor.hex("#F5F5F5")
    /// 导航栏背景色
    var navigationBarColor = UIColor.white
    /// 导航栏背阴影线条景色
    var navigationBarShadowColor = UIColor.clear
}
