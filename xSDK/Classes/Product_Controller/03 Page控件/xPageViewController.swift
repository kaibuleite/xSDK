//
//  xPageViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/21.
//

import UIKit

public class xPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Handler
    /// 切换页数
    public typealias xHandlerChangePage = (Int) -> Void
    /// 点击分页
    public typealias xHandlerClickPage = (Int) -> Void
    
    // MARK: - Public Property
    /// 是否开启定时器
    public var isOpenAutoChangeTimer = true
    /// 刷新频率(默认5s)
    public var changeInterval = TimeInterval(5)

    // MARK: - Private Property
    /// 当前页数编号
    private var currentPage = 0
    /// 定时器
    private var timer : Timer?
    /// 单页子控制器
    private var itemViewControllerArray = [UIViewController]()
    /// 切换回调
    private var changeHandler : xHandlerChangePage?
    /// 点击回调
    private var clickHandler : xHandlerClickPage?
    
    // MARK: - 内存释放
    deinit {
        self.delegate = nil
        self.dataSource = nil
        self.closeTimer()
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("🐔_PVC \(name)")
    }

    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isOpenAutoChangeTimer else { return }
        self.openTimer()
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.closeTimer()
    }
    
    // MARK: - Public Func
    public class func quickInstancetype() -> Self {
        let vc = xPageViewController.new(storyboard: "xPageViewController")
        return vc as! Self
    } 
    /// 刷新数据（默认样式）
    /// - Parameters:
    ///   - pictureArray: 图片链接
    ///   - handlerChange: 切换回调
    ///   - handlerClick: 点击回调
    public func reload(pictureArray : [String],
                       change handler1 : @escaping xHandlerChangePage,
                       click handler2 : @escaping xHandlerClickPage)
    {
        var vcArray = [UIViewController]()
        for url in pictureArray {
            let vc = xDefaultOnePageItemViewController.quickInstancetype()
            vc.pictureUrl = url
            vcArray.append(vc)
        }
        self.reload(itemViewControllerArray: vcArray, change: handler1, click: handler2)
    }
    /// 加载自定义组件数据
    /// - Parameters:
    ///   - itemViewControllerArray: 视图控制器列表
    ///   - handler: 回调
    public func reload(itemViewControllerArray : [UIViewController],
                       change handler1 : @escaping xHandlerChangePage,
                       click handler2 : @escaping xHandlerClickPage)
    {
        guard itemViewControllerArray.count > 0 else {
            x_warning("数据不能为0")
            return
        }
        guard let vc = itemViewControllerArray.first else {
            x_warning("视图控制器初始化失败")
            return
        }
        self.dataSource = self
        self.delegate = self
        // 绑定数据
        self.itemViewControllerArray = itemViewControllerArray
        self.changeHandler = handler1
        self.clickHandler = handler2
        // 设置子控制器样式
        for (i, vc) in itemViewControllerArray.enumerated()
        {
            vc.view.tag = i
            vc.view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            vc.view.addGestureRecognizer(tap)
        }
        self.setViewControllers([vc], direction: .forward, animated: false) {
            (finish) in
        }
    }
    
    // MARK: - Private Func
    /// 开启定时器
    private func openTimer()
    {
        let timer = Timer.x_new(timeInterval: self.changeInterval, repeats: true) {
            [weak self] (sender) in
            guard let ws = self else { return }
            guard ws.itemViewControllerArray.count > 0 else { return }
            ws.change(to: ws.currentPage + 1)
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    /// 关闭定时器
    private func closeTimer()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 换页
    private func change(to page : Int)
    {
        // xLog("系统换页")
        guard page != self.currentPage else { return }
        var direction = UIPageViewController.NavigationDirection.forward
        if page < self.currentPage {
            direction = .reverse
        }
        self.currentPage = self.safe(page: page)
        let vc = self.itemViewControllerArray[self.currentPage]
        self.view.isUserInteractionEnabled = false
        self.setViewControllers([vc], direction: direction, animated: true) {
            [unowned self] (finish) in
            // xLog("系统换页完成")
            self.view.isUserInteractionEnabled = true
            self.changeHandler?(self.currentPage)
        }
    }
    /// 返回安全的页码
    private func safe(page : Int) -> Int
    {
        let count = self.itemViewControllerArray.count
        guard count > 0 else { return 0 }
        if page >= count {
            return 0
        }
        if page <= 0 {
            return count - 1
        }
        return page
    }
    /// 手势事件
    @objc private func tapItem(_ gesture : UITapGestureRecognizer)
    {
        guard let page = gesture.view?.tag else { return }
        self.clickHandler?(page)
    }
    
    // MARK: - UIPageViewControllerDataSource
    /// 上一页
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let page = self.safe(page: self.currentPage - 1)
        let vc = self.itemViewControllerArray[page]
        return vc
    }
    /// 下一页
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let page = self.safe(page: self.currentPage + 1)
        let vc = self.itemViewControllerArray[page]
        return vc
    }
    
    // MARK: - UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController])
    {
        // xLog("用户开始换页")
        self.closeTimer()
        guard let vc = pendingViewControllers.last else { return }  // 换页目标加载失败
        self.currentPage = vc.view.tag
    }
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        // xLog("用户换页完成")
        if self.isOpenAutoChangeTimer {
            self.openTimer()
        }
        if completed == false {
            // 换页失败（取消操作、拖拽幅度不够。。。）
            guard let vc = previousViewControllers.last else { return } // 原来的页数据加载失败
            self.currentPage = vc.view.tag
        }
        self.changeHandler?(self.currentPage)
    }
}
