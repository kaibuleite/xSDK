//
//  xAppManager.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xAppManager: NSObject {

    // MARK: - Public Property
    /// 单例
    public static let shared = xAppManager()
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
    public var tableViewBackgroundColor = UIColor.groupTableViewBackground
    /// 导航栏背景色
    public var navigationBarColor = UIColor.x_hex("F7F6F6")
    /// 导航栏背阴影线条景色
    public var navigationBarShadowColor = UIColor.lightGray
}
