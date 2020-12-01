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
    
    // TODO: - 应用配置
    /// 是否是测试环境
    public var isDebug = true
    /// 是否打印控制台信息
    public var isLog = true
    /// 是否打印xModel参数缺少信息
    public var isLogModelNoPropertyTip = false
    
    // TODO: - 常用参数（可编辑）
    /// 主题色
    public var themeColor = UIColor.xNew(hex: "#487FFC")
    /// TableView背景色
    public var tableViewBackgroundColor = UIColor.groupTableViewBackground
    /// 导航栏背景色
    public var navigationBarColor = UIColor.xNew(hex: "F7F6F6")
    /// 导航栏背阴影线条景色
    public var navigationBarShadowColor = UIColor.lightGray
    /// 占位色
    public var placeholderColor = UIColor.xNew(hex: "F5F5F5")
    /// 占位图_默认
    public var placeholderImage = UIColor.xNew(hex: "F5F5F5").xToImage(size: .init(width: 5, height: 5))
    /// 占位图_头像
    public var placeholderImage_avatar = UIColor.xNew(hex: "F5F5F5").xToImage(size: .init(width: 5, height: 5))
    /// 占位图_横幅
    public var placeholderImage_banner = UIColor.xNew(hex: "F5F5F5").xToImage(size: .init(width: 5, height: 5))
    
    // TODO: - 应用信息
    /// 名称
    public static var appBundleName : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
        let ret = name as? String ?? ""
        return ret
    }
    /// ID
    public static var appBundleID : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier")
        let ret = name as? String ?? ""
        return ret
    }
    /// 版本号
    public static var appVersion : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let ret = name as? String ?? ""
        return ret
    }
    /// 编译信息
    public static var appBuildVersion : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        let ret = name as? String ?? ""
        return ret
    }
}
