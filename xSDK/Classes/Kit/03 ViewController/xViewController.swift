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
    @IBOutlet open weak var topNaviBar: UIView?
    /// 安全区域
    @IBOutlet open weak var safeView: UIView?
    /// 子控制器容器
    @IBOutlet open weak var childContainer: UIView?
    
    // MARK: - IBInspectable Property
    /// 控制器描述
    @IBInspectable
    public var xTitle : String = "控制器描述"
    
    // MARK: - Public Property
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isLoadRequestDataCompleted = true
    /// 是否是父控制器
    public var isRootParentViewController = false
    /// 顶部遮罩(状态栏)
    public let safeTopMaskView = UIView()
    /// 底部遮罩(Tabbar菜单)
    public let safeBottomMaskView = UIView()
    
    // MARK: - 内存释放
    deinit {
        if self.isRootParentViewController {
            x_log("****************************")
        }
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("♻️_\(self.xTitle) \(name)")
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
            
            if let safeView = self.safeView {
                var frame = safeView.bounds
                
                frame.origin.y -= frame.height
                self.safeTopMaskView.frame = frame
                self.safeTopMaskView.backgroundColor = self.topNaviBar?.backgroundColor ?? .clear
                
                frame.origin.y += 2 * frame.height
                self.safeBottomMaskView.frame = frame
                self.safeBottomMaskView.backgroundColor = .clear
                
                safeView.addSubview(self.safeTopMaskView)
                safeView.addSubview(self.safeBottomMaskView)
                
            }
            
            self.initKit()
            self.initChildrenViewController()
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
    open func initKit() { }
    /// 初始化子控制器
    open func initChildrenViewController() { }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open class func quickInstancetype() -> Self
    {
        let vc = self.init()
        return vc
    }
}
