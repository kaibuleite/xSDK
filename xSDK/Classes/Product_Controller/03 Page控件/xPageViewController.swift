//
//  xPageViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/21.
//

import UIKit

public class xPageViewController: UIPageViewController {

    // MARK: - Enum
    /// 拖拽方向
    public enum xDraggingDirection {
        /// 无
        case none
        /// 下一个
        case next
        /// 上一个
        case previous
    }
    
    // MARK: - Handler
    /// 切换页数
    public typealias xHandlerChangePage = (Int) -> Void
    /// 滚动中
    public typealias xHandlerScrolling = (CGPoint, xDraggingDirection) -> Void
    /// 点击分页
    public typealias xHandlerClickPage = (Int) -> Void
    
    // MARK: - Public Property
    /// 是否开启定时器
    public var isOpenAutoChangeTimer = true
    /// 刷新频率(默认5s)
    public var changeInterval = TimeInterval(5)
    /// 是否拖拽中
    public var isDragging = false
    /// 当前页数编号
    public var currentPage = 0
    /// 目标页数编号
    public var pendingPage = 0

    // MARK: - Private Property
    /// 定时器
    private var timer : Timer?
    /// 滚动容器
    private var contentScrollView : UIScrollView?
    /// 单页子控制器
    private var itemViewControllerArray = [UIViewController]()
    /// 滚动回调
    private var scrollingHandler : xHandlerScrolling?
    /// 切换回调
    private var changeHandler : xHandlerChangePage?
    /// 点击回调
    private var clickHandler : xHandlerClickPage?
    
    // MARK: - 内存释放
    deinit {
        self.delegate = nil
        self.dataSource = nil
        self.contentScrollView?.delegate = nil
        
        self.scrollingHandler = nil
        self.changeHandler = nil
        self.clickHandler = nil
        
        self.closeTimer()
        
        xLog("🐔_PVC \(self.xClassStruct.name)")
    }

    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .clear
        // 绑定滚动容器
        for obj in self.view.subviews {
            guard let scrol = obj as? UIScrollView else { continue }
            self.contentScrollView = scrol
            break
        }
        // 关联代理
        self.dataSource = self
        self.delegate = self
        self.contentScrollView?.delegate = self
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isOpenAutoChangeTimer {
            self.openTimer()
        }
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.closeTimer()
    }
    
    // MARK: - Public Func
    // TODO: 实例化对象
    /// 快速实例化对象(storyboard比类名少指定后缀)
    public override class func quickInstancetype() -> Self
    {
        let vc = xPageViewController.xNew(storyboard: "xPageViewController")
        return vc as! Self
    }
    public class func quickInstancetype(navigationOrientation: UIPageViewController.NavigationOrientation) -> Self
    {
        let vc = xPageViewController.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
        return vc as! Self
    }
    
    // TODO: 数据加载
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
    ///   - handler1: 滚动回调
    ///   - handler2: 切换page回调
    ///   - handler3: 单击触摸事件回调
    public func reload(itemViewControllerArray : [UIViewController],
                       scrolling handler1 : xHandlerScrolling? = nil,
                       change handler2 : @escaping xHandlerChangePage,
                       click handler3 : xHandlerClickPage?)
    {
        guard itemViewControllerArray.count > 0 else {
            xWarning("数据不能为0")
            return
        }
        guard let first = itemViewControllerArray.first else {
            xWarning("视图控制器初始化失败")
            return
        }
        // 绑定数据
        self.itemViewControllerArray = itemViewControllerArray
        self.scrollingHandler = handler1
        self.changeHandler = handler2
        self.clickHandler = handler3
        self.currentPage = 0
        self.pendingPage = 0
        // 设置子控制器样式
        for (i, vc) in itemViewControllerArray.enumerated()
        {
            vc.view.tag = i
            // 没有单击事件回调就不用添加手势了
            guard let _ = self.clickHandler else { continue }
            vc.view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            vc.view.addGestureRecognizer(tap)
        }
        self.setViewControllers([first], direction: .forward, animated: false) {
            (finish) in
        }
    }
    
    // TODO: 其他
    /// 换页
    public func change(to page : Int)
    {
        // xLog("系统换页")
        guard page != self.currentPage else { return }
        // 获取滚动方向
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
    
    // MARK: - Private Func
    // TODO: 定时器
    /// 开启定时器
    private func openTimer()
    {
        self.closeTimer()   // 防止定时器多开
        let timer = Timer.xNew(timeInterval: self.changeInterval, repeats: true) {
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
    
    // TODO: 其他
    /// 返回安全的页码
    private func safe(page : Int) -> Int
    {
        let count = self.itemViewControllerArray.count
        guard count > 0 else { return 0 }
        if page >= count {
            return 0
        }
        if page < 0 {
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
    
}

// MARK: - UIPageViewControllerDataSource
extension xPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        // xLog("上一页")
        let page = self.safe(page: viewController.view.tag - 1)
        let vc = self.itemViewControllerArray[page]
        return vc
    }
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        // xLog("下一页")
        let page = self.safe(page: viewController.view.tag + 1)
        let vc = self.itemViewControllerArray[page]
        return vc
    }
}

// MARK: - UIPageViewControllerDelegate
extension xPageViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController])
    {
        // xLog("用户开始换页")
        self.closeTimer()
        // 框架只考虑单页，所以数组其实只有1个元素
        guard let vc = pendingViewControllers.last else { return }
        let page = vc.view.tag
        self.pendingPage = page
    }
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool)
    {
        // xLog("用户换页完成")
        if self.isOpenAutoChangeTimer {
            self.openTimer()
        }
        if completed {
            self.currentPage = self.pendingPage
        }
        else {
            guard let vc = previousViewControllers.first else { return }
            self.currentPage = vc.view.tag
        }
        self.changeHandler?(self.currentPage)
    }
}

// MARK: - UIScrollViewDelegate
extension xPageViewController: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isDragging = false
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // 没有回调就不管了，较少CPU开销
        guard let handler = self.scrollingHandler else { return }
        // 计算当前页的偏移量
        let vc = self.itemViewControllerArray[self.currentPage]
        let p = vc.view.convert(CGPoint(), to: self.view)
        var offset = CGPoint.zero
        var direction = xDraggingDirection.none
        switch self.navigationOrientation {
        case .horizontal:
            let w = self.view.frame.width
            offset.x = CGFloat(self.currentPage) * w - p.x
            if p.x != 0 {
                direction = p.x > 0 ? .previous : .next
            }
            // 跨页处理
            if CGFloat(abs(p.x)) >= w {
                self.currentPage += (direction == .next) ? 1 : -1
                self.currentPage = self.safe(page: self.currentPage)
            }
            // 边缘处理
            let minX = CGFloat.zero
            let maxX = CGFloat(self.itemViewControllerArray.count - 1) * w
            if offset.x < minX {
                offset.x += maxX
            }
            if offset.x > maxX {
                offset.x -= maxX
            }
        default:
            let h = self.view.frame.height
            offset.y = CGFloat(self.currentPage) * h - p.y
            if p.y != 0 {
                direction = p.y > 0 ? .previous : .next
            }
            // 跨页处理
            if CGFloat(abs(p.y)) >= h {
                self.currentPage += (direction == .next) ? 1 : -1
                self.currentPage = self.safe(page: self.currentPage)
            }
            // 边缘处理
            let minY = CGFloat.zero
            let maxY = CGFloat(self.itemViewControllerArray.count - 1) * h
            if offset.y < minY {
                offset.y += maxY
            }
            if offset.y > maxY {
                offset.y -= maxY
            }
        }
        // xLog(offset)
        handler(offset, direction)
    }
}
