//
//  xNavigationController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xNavigationController: UINavigationController {
    
    // MARK: - 公有变量
    /// 当前子界面的编号
    public var currentViewControllerIndex = 0
    /// 是否显示返回按钮上的文字(默认不显示)
    public var isShowBackItemTitle = false
    
    // MARK: - 内存释放
    deinit {
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("💥_NVC \(name)")
    }
    
    // MARK: - 视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        // 强制白天模式
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    // 修改状态栏样式
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    // MARK: - 重载方法
    override func pushViewController(_ viewController: UIViewController,
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
        self.currentViewControllerIndex += 1
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.currentViewControllerIndex -= 1
        return super.popViewController(animated: animated)
    }
    
    // MARK: - 获取当前子控制器
    /// 获取当前子控制器
    ///
    /// - Returns: 返回子控制器
    open func getCurrentViewController() -> UIViewController?
    {
        guard self.currentViewControllerIndex > 0, self.currentViewControllerIndex < self.children.count else {
            return nil
        }
        let vc = self.children[self.currentViewControllerIndex]
        return vc
    }
}
