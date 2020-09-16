//
//  xGlobalValue.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

// MARK: - 自定义宏
/// 屏幕宽度
public let x_width = UIScreen.main.bounds.size.width
/// 屏幕高度
public let x_height = UIScreen.main.bounds.size.height
/// 状态栏高度
public let x_statusHeight = UIApplication.shared.statusBarFrame.height
/// 导航栏高度
public let x_navigationBarHeight = UINavigationController().navigationBar.frame.height
/// 菜单栏高度
public let x_tabbarHeight = UITabBarController().tabBar.frame.height
/// 重新登录提示
public let x_NotificationReLogin = Notification.Name.init("x重新登录")
