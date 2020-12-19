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
/// 重新登录提示
public let xNotificationPlaySound = Notification.Name.init("x播放推送音效")

/// 当前窗口
public var xKeyWindow : UIWindow?
{
    var win : UIWindow?
    if #available(iOS 13.0, *) {
        let sceneList = UIApplication.shared.connectedScenes
        if let scene = sceneList.first {
            if let delegate = scene.delegate as? UIWindowSceneDelegate {
                win = delegate.window as? UIWindow
            }
        }
        if win == nil {
            win = UIApplication.shared.windows.last
        }
    }
    else {
        win = UIApplication.shared.keyWindow
    }
    return win
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
