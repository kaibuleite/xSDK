//
//  xViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xViewController: UIViewController {
    
    // MARK: - 关联变量
    /// 自定义导航栏
    @IBOutlet public weak var topNaviBar: UIView?
    /// 安全区域
    @IBOutlet public weak var safeView: UIView?
    /// 子控制器容器
    @IBOutlet public weak var childContainer: UIView?
    
    // MARK: - 公有变量
    /// 控制器描述
    @IBInspectable public var xTitle : String = "控制器描述"
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isLoadRequestDataCompleted = true
    /// 是否是父控制器
    public var isRootParentViewController = false
    /// 顶部遮罩(状态栏)
    lazy var safeTopMaskView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear   // 默认色
        return view
    }()
    /// 底部遮罩(Tabbar菜单)
    lazy var safeBottomMaskView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear   // 默认色
        return view
    }()
    // MARK: - 内存释放
    deinit {
        if self.isRootParentViewController {
            x_log("****************************")
        }
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("♻️_\(self.xTitle) \(name)")
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isAppear = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isAppear = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - 初始化子控制器
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let ident = segue.identifier else { return }
        if ident.hasPrefix("Child")
        || ident.hasPrefix("child") {
            self.addChild(segue.destination)   // 绑定父控制器
        }
    }
    
    // MARK: - 子类重写
    /// 初始化UI
    open func initKit() { x_log("子类重写") }
    /// 初始化子控制器
    open func initChildrenViewController() { x_log("子类重写") }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open class func quickInstancetype() -> Self {
        let vc = self.init()
        return vc
    }
}
