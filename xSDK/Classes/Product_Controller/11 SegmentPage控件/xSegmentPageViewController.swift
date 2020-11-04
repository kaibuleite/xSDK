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
        let config = xSegmentConfig.init()
        config.line.color = .red
        config.line.marginBottom = 2
        config.titleColor.choose = .red
        self.setSegmentConfig(config)
    }
    open override func addKit() {
        self.segment.frame = self.segmentContainer.bounds
        self.segmentContainer.addSubview(self.segment)
    }
    open override func addChildren() {
        self.xAddChild(self.pageViewController, in: self.pageContainer)
    }
    
    // MARK: - Public Func
    /// 设置分段视图配置
    public func setSegmentConfig(_ config : xSegmentConfig)
    {
        self.segment.config = config
    }
    
    /// 加载数据
    /// - Parameters:
    ///   - segmentDataArray: 分段数据
    ///   - segmentItemFillMode: 分段填充样式
    ///   - pageDataArray: 分页数据
    ///   - isShowSegmentScrollAnimation: 是否显示Segment滚动动画
    ///   - handler2: 切换分页回调
    ///   - handler3: 点击分页回调
    public func reload(segmentDataArray : [String],
                       pageDataArray : [UIViewController],
                       isShowSegmentScrollAnimation : Bool = true,
                       //scrolling handler1 : xPageViewController.xHandlerScrolling? = nil,
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
        // 部分配置需要限制死
        self.segment.config.spacing = 0
        self.segment.config.line.widthOfItemPercent = 1
        /*
         主线程加载数据，防止UI的frame出错
         这里GCD内的代码会在 addKit 和 addChildren 方法后执行
         */
        DispatchQueue.main.async {
            // 加载分段数据
            self.segment.reload(titleArray: segmentDataArray, fillMode: self.segment.config.fillMode) {
                [unowned self] (idx) in
                self.view.isUserInteractionEnabled = false
                self.isHandlerPageScrolling = false // 该状态无需监听Page的滚动回调
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    self.view.isUserInteractionEnabled = true
                    self.isHandlerPageScrolling = true  // 恢复监听状态
                })
                self.pageViewController.change(to: idx)
            }
            self.segment.updateSegmentStyle(choose: 0)
            // 加载分页数据
            if isShowSegmentScrollAnimation == false {
                // Segment没有滚动动画
                self.pageViewController.reload(itemViewControllerArray: pageDataArray) {
                    [unowned self] (page) in
                    self.segment.updateSegmentStyle(choose: page)
                    handler2(page)
                    
                } click: {
                    (page) in
                    handler3?(page)
                }
                return
            }
            self.pageViewController.reload(itemViewControllerArray: pageDataArray) {
                [unowned self] (data, direction) in
                guard self.isHandlerPageScrolling else { return }
                // 声明计算参数
                let segW = self.segment.contentScroll.contentSize.width
                let segCfg = self.segment.config
                let itemW = self.segment.itemViewArray[data.toPage].bounds.width
                let lineY = self.segment.bounds.height - segCfg.line.height - segCfg.line.marginBottom
                var lineX = CGFloat(data.fromPage) * itemW
                switch direction {
                case .next:     lineX += itemW * data.progress
                case .previous: lineX -= itemW * data.progress
                }
                // 更新指示线位置
                let path = UIBezierPath.init()
                var pos1 = CGPoint.init(x: lineX, y: lineY)
                path.move(to: pos1)
                pos1.x += itemW
                path.addLine(to: pos1)
                if lineX < 0 {
                    // 1 <<< n
                    var pos2 = CGPoint.init(x: segW, y: lineY)
                    path.move(to: pos2)
                    pos2.x = segW + lineX
                    path.addLine(to: pos2)
                }
                if lineX + itemW > segW {
                    // n >>> 1
                    var pos2 = CGPoint.init(x: 0, y: lineY)
                    path.move(to: pos2)
                    pos2.x = lineX + itemW - segW
                    path.addLine(to: pos2)
                }
                self.segment.lineLayer.path = path.cgPath
                // xLog("\(data.fromPage)->\(data.toPage), x=\(Double(lineX).xToString(precision: 0)), p=\(Double(data.progress * 100).xToString(precision: 1))%")
                // 修改Segment内容颜色
                // 为了防止拖动过快，设置个阈值，不然来不及清空颜色会导致部分item颜色不统一
                var ratio = data.progress
                if data.progress <= 0.1 {
                    ratio = 0
                }
                if data.progress >= 0.9 {
                    ratio = 1
                }
                let color1 = self.segment.config.titleColor.chooseMixNormal(ratio: ratio)
                self.segment.setItemTitleColor(at: data.fromPage, color: color1)
                if data.fromPage != data.toPage {
                    let color2 = self.segment.config.titleColor.normalMixChoose(ratio: ratio)
                    self.segment.setItemTitleColor(at: data.toPage, color: color2)
                }
                else {
                    for i in 0 ..< self.segment.itemViewArray.count {
                        guard i != data.fromPage else { continue }
                        self.segment.setItemNormalStyle(at: i)
                    }
                }
                
            } change: {
                [unowned self] (page) in
                self.segment.updateSegmentStyle(choose: page)
                handler2(page)
                
            } click: {
                (page) in
                handler3?(page)
            }
        }
    }
    
}
