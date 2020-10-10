//
//  xViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xViewController: UIViewController {
    
    // MARK: - IBOutlet Property
    /// 自定义导航栏
    @IBOutlet open weak var topNaviBar: xNavigationView?
    /// 安全区域
    @IBOutlet open weak var safeView: xSafeView?
    /// 子控制器容器
    @IBOutlet open weak var childContainer: xContainerView?
    
    // MARK: - IBInspectable Property
    /// 控制器描述
    @IBInspectable public var xTitle : String = ""
    
    // MARK: - Public Property
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isLoadRequestDataCompleted = true
    /// 是否是父控制器
    public var isRootParentViewController = false
    
    // MARK: - 内存释放
    deinit {
        if self.isRootParentViewController {
            xLog("****************************")
        }
        xLog("♻️ \(self.xTitle) \(self.xClassStruct.name)")
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
        // 模态全屏
        self.modalPresentationStyle = .fullScreen
        // 主线程初始化UI
        DispatchQueue.main.async {
            self.addKit()
            self.addChildren()
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isAppear = true
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isAppear = false
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let ident = segue.identifier else { return }
        if ident.hasPrefix("Child")
        || ident.hasPrefix("child") {
            self.addChild(segue.destination)   // 绑定父控制器
        }
    }
    
    // MARK: - Open Func
    /// 初始化UI
    @objc open func addKit() { }
    /// 初始化子控制器
    @objc open func addChildren() { }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open class func quickInstancetype() -> Self
    {
        let vc = self.init()
        return vc
    }
}
