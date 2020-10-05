//
//  xGlobalValue.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

// MARK: - Public Property
/// 屏幕宽度
public let xScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
public let xScreenHeight = UIScreen.main.bounds.size.height
/// 状态栏高度
public let xStatusHeight = UIApplication.shared.statusBarFrame.height
/// 导航栏高度
public let xNavigationBarHeight = UINavigationController().navigationBar.frame.height
/// 菜单栏高度
public let xTabbarHeight = UITabBarController().tabBar.frame.height


/// 重新登录提示
public let xNotificationReLogin = Notification.Name.init("x重新登录")


/// 当前窗口
public var xKeyWindow : UIWindow? {
    var ret : UIWindow?
    if #available(iOS 13.0, *) {
        guard let scene = UIApplication.shared.connectedScenes.first else { return nil }
        guard let winScene = scene as? UIWindowScene else { return nil }
        ret = UIWindow.init(windowScene: winScene)
    }
    else {
        ret = UIApplication.shared.keyWindow
    }
    return ret
}
/// 秒级时间戳
public var xTimeStamp : Int
{
    let ts = Date().timeIntervalSince1970
    let ret = Int(ts)
    return ret
}
/// 毫秒级时间戳
public var xMillisecondTimeStamp : Int
{
    let ts = Date().timeIntervalSince1970
    let ret = Int(ts * 1000)
    return ret
}
