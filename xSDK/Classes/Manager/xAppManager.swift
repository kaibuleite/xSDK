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
    
    
    /// 是否是测试环境
    public var isDebug = true
    /// 是否打印控制台信息
    public var isLog = true
    /// 是否打印xModel参数缺少信息
    public var isLogModelNoPropertyTip = false
    
    /// 主题色
    public var themeColor = UIColor.x_hex("#487FFC")
    /// TableView背景色
    public var tableViewBackgroundColor = UIColor.x_hex("#F5F5F5")
    /// 导航栏背景色
    public var navigationBarColor = UIColor.white
    /// 导航栏背阴影线条景色
    public var navigationBarShadowColor = UIColor.clear
}
