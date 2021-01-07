//
//  xTabBarController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xTabBarController: UITabBarController {
    
    // MARK: - 内存释放
    deinit {
        xLog("💥 TBC \(self.xClassStruct.name)")
    }
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 强制白天模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        DispatchQueue.main.async {
            self.addKit()
            self.addChildren()
            self.requestData()
        }
    }
    
    /// 设置默认标题颜色
    /// - Parameter color: 指定颜色
    public func setNormalItemTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let normal = appearance.stackedLayoutAppearance.normal
            normal.titleTextAttributes = attr
            self.tabBar.standardAppearance = appearance;
        }
        else {
            self.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        }
    }
    
    /// 设置选中标题颜色
    /// - Parameter color: 指定颜色
    public func setSelectedItemTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let selected = appearance.stackedLayoutAppearance.selected
            selected.titleTextAttributes = attr
            self.tabBar.standardAppearance = appearance;
        }
        else {
            self.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        }
    }
}
