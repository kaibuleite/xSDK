//
//  xSegmentPageViewController.swift
//  xSDK
//
//  Created by Mac on 2020/10/29.
//

import UIKit

open class xSegmentPageViewController: xViewController {
    
    // MARK: - Handle
    /// 显示分页
    public typealias xHandlerShowPage = (Int, UIViewController) -> Void
    
    // MARK: - IBOutlet Property
    /// 分段容器
    @IBOutlet weak var segmentContainer: xContainerView!
    /// 分页容器
    @IBOutlet weak var pageContainer: xContainerView!
    
    // MARK: - Private Property
    /// 分段
    let segment = xSegmentView.init()
    /// 分页
    let pageViewController = xPageViewController.quickInstancetype(navigationOrientation: .horizontal)
    /// 是否需要监听Page滚动回调
    var isHandlerPageScrolling = true
    /// 回调
    var showHandler : xHandlerShowPage?
    
    // MARK: - 内存释放
    deinit {
        self.showHandler = nil
    }
    
    // MARK: - Open Override Func
    open override class func quickInstancetype() -> Self {
        let vc = xSegmentPageViewController.xNew(storyboard: "xSegmentPageViewController")
        return vc as! Self
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 配置样式
        self.pageViewController.isOpenAutoChangeTimer = false
        // 添加分段配置
        self.setSegmentConfig()
    }
    open override func addKit() {
        self.segment.frame = self.segmentContainer.bounds
        self.segmentContainer.addSubview(self.segment)
    }
    open override func addChildren() {
        self.xAddChild(self.pageViewController, in: self.pageContainer)
    }
    
    // MARK: - Open Func
    /// 设置分段视图配置
    open func setSegmentConfig()
    {
        let config = xSegmentConfig.init()
        config.line.color = .red
        config.line.marginBottom = 2
        config.titleColor.choose = .red
        self.segment.config = config
    }
    
    // MARK: - Public Func
    /// 加载数据
    /// - Parameters:
    ///   - segmentDataArray: 分段数据
    ///   - segmentItemFillMode: 分段填充样式
    ///   - pageDataArray: 分页数据
    public func reload(segmentDataArray : [String],
                       segmentItemFillMode : xSegmentConfig.xSegmentItemFillMode = .fillEqually,
                       pageDataArray : [UIViewController],
                       scrolling handler1 : xPageViewController.xHandlerScrolling? = nil,
                       change handler2 : @escaping xPageViewController.xHandlerChangePage,
                       click handler3 : xPageViewController.xHandlerClickPage? = nil)
    {
        guard segmentDataArray.count > 0 else {
            xWarning("没数据")
            return
        }
        guard segmentDataArray.count == pageDataArray.count else {
            xWarning("标题和分页数不一样")
            return
        }
        /*
         主线程加载数据，防止UI的frame出错
         这里GCD内的代码会在 addKit 和 addChildren 方法后执行
         */
        DispatchQueue.main.async {
            // 加载分段数据
            self.segment.reload(titleArray: segmentDataArray, fillMode: segmentItemFillMode) {
                [unowned self] (idx) in
                self.isHandlerPageScrolling = false // 该状态无需监听Page的滚动回调
                self.pageViewController.change(to: idx)
            }
            self.segment.updateSegmentStyle(choose: 0)
            // 加载分页数据
            /* 简易设置
            self.pageViewController.reload(itemViewControllerArray: pageDataArray, scrolling: handler1, change: {
                [unowned self] (page) in
                self.isHandlerPageScrolling = true  // 恢复监听状态
                self.segment.updateSegmentStyle(choose: page)
                handler2(page)
                
            }, click: handler3)
             */
            /* 详细设置
             */
            self.pageViewController.reload(itemViewControllerArray: pageDataArray) {
                [unowned self] (offset, direction) in
                guard self.isHandlerPageScrolling else { return }
                // 声明计算参数
                let count = pageDataArray.count
                let width = self.view.bounds.width
                let page1 = self.pageViewController.currentPage
                let page2 = self.pageViewController.pendingPage
                var ratio = fmod(offset.x, width) / width   // 滚动比例
                if direction == .previous {
                    ratio = 1 - ratio
                }
                // 更新指示线位置
                let path = UIBezierPath.init()
                let segCfg = self.segment.config
                let itemW = width / CGFloat(count)  // 单段宽度
                let lineW = itemW * self.segment.config.line.widthOfItemPercent
                let lineX = offset.x / CGFloat(count)
                let lineY = self.segment.bounds.height - segCfg.line.height - segCfg.line.marginBottom
                if abs(page1 - page2) == count - 1 {
                    // 两边处理
                    switch direction {
                    case .next: // n >> 0 尾部到头部
                        var pos = CGPoint.zero
                        pos.y = lineY
                        pos.x = (itemW - lineW) / 2 // 左侧起点
                        path.move(to: pos)
                        pos.x += lineX      // 左侧终点
                        path.addLine(to: pos)
                        pos.x = width - itemW + lineX + (itemW - lineW) / 2  // 右侧起点
                        path.move(to: pos)
                        pos.x = width - itemW + lineW   // 右侧终点
                        path.addLine(to: pos)
                        self.segment.lineLayer.path = path.cgPath
                    case .previous:    // 0 >> n 头部到尾部
                        var pos = CGPoint.zero
                        pos.y = lineY
                        pos.x = (itemW - lineW) / 2 // 左侧起点
                        path.move(to: pos)
                        pos.x += width - lineX      // 左侧终点
                        path.addLine(to: pos)
                        pos.x = width - itemW + lineX + (itemW - lineW) / 2  // 右侧起点
                        path.move(to: pos)
                        pos.x = width - itemW + lineW   // 右侧终点
                        path.addLine(to: pos)
                        self.segment.lineLayer.path = path.cgPath
                    case .none:
                        break
                    }
                }
                else {
                    // 中间处理
                    var pos = CGPoint.zero
                    pos.y = lineY
                    pos.x = lineX + (itemW - lineW) / 2 // 起点位置
                    path.move(to: pos)
                    pos.x += lineW  // 终点位置
                    path.addLine(to: pos)
                    self.segment.lineLayer.path = path.cgPath
                }
                
                // 修改Segment内容颜色
                if page1 != page2, direction != .none {
                    let color1 = self.segment.config.titleColor.chooseMixNormal(ratio: ratio)
                    self.segment.setItemTitleColor(at: page1, color: color1)
                    let color2 = self.segment.config.titleColor.normalMixChoose(ratio: ratio)
                    self.segment.setItemTitleColor(at: page2, color: color2)
                }
                xLog("\(page1) >>> \(page2)", "\(offset.x) = \(lineX)")
                handler1?(offset, direction)
                
            } change: {
                [unowned self] (page) in
                self.segment.updateSegmentStyle(choose: page)
                handler2(page)
                self.isHandlerPageScrolling = true  // 恢复监听状态
                
            } click: {
                (page) in
                handler3?(page)
            }
        }
    }
    
}
