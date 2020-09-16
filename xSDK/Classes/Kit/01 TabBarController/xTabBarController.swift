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
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("💥_TBR \(name)")
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
    
    // MARK: - Open Func
    /// 初始化UI
    open func initKit() { }
    /// 初始化子控制器
    open func initChildrenViewController() { }

}
