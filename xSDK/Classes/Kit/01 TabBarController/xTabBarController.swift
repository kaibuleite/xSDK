//
//  xTabBarController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xTabBarController: UITabBarController {
    
    // MARK: - 内存释放
    deinit {
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("💥_TBR \(name)")
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
        DispatchQueue.main.async {
            self.initKit()
            self.initChildrenViewController()
        }
    }
    
    // MARK: - 方法重写
    /// 初始化UI
    open func initKit() { }
    /// 初始化子控制器
    open func initChildrenViewController() { }

}
