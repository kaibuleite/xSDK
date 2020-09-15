//
//  xNavigationController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xNavigationController: UINavigationController {
    
    // MARK: - Public Property
    /// 是否显示返回按钮上的文字(默认不显示)
    open var isShowBackItemTitle = false
    
    // MARK: - 内存释放
    deinit {
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("💥_NVC \(name)")
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
            self.initKit()
            self.initChildrenViewController()
        }
    }
    /// 修改状态栏样式
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    open override func pushViewController(_ viewController: UIViewController,
                                          animated: Bool) {
        // 判断是否隐藏返回按钮上的文字
        if self.isShowBackItemTitle == false {
            let item = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = item
        }
        else {
            // let title = self.getCurrentViewController()?.title
        }
        super.pushViewController(viewController, animated: animated)
    }
    open override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    // MARK: - Open Func
    /// 初始化UI
    open func initKit() { }
    /// 初始化子控制器
    open func initChildrenViewController() { }
    /// 设置导航栏颜色
    /// - Parameter color: 指定颜色
    open func setBarBackgroupColor(_ color : UIColor)
    {
        self.navigationBar.barTintColor = color
        self.navigationBar.isTranslucent = false
    }
    /// 设置下边缘线颜色
    /// - Parameter color: 指定颜色
    open func setBarShadowColor(_ color : UIColor)
    {
        self.navigationBar.setBackgroundImage(color.x_toImage(),
                                              for: .default)
        self.navigationBar.shadowImage = color.x_toImage()
    }
    /// 获取指定类型的子控制器
    open func getChildrenClass(_ name : AnyClass) -> [UIViewController]
    {
        var ret = [UIViewController]()
        self.children.forEach {
            (obj) in
            if obj.isMember(of: name) {
                ret.append(obj)
            }
        }
        return ret
    }
    /// 释放掉指定类型的子控制器
    open func releaseChildrenClass(list : [AnyClass],
                                     animated : Bool = false)
    {
        var childArray = self.children
        list.forEach {
            (release_class) in
            for (i, obj) in childArray.enumerated() {
                guard obj.isMember(of: release_class) else { continue }
                childArray.remove(at: i)
                break
            }
        }
        self.setViewControllers(childArray, animated: animated)
    }
}
