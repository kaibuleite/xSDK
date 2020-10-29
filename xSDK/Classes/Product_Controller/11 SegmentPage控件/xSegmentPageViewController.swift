//
//  xSegmentPageViewController.swift
//  xSDK
//
//  Created by Mac on 2020/10/29.
//

import UIKit

open class xSegmentPageViewController: xViewController {

    // MARK: - Enum
    
    // MARK: - Handle
    /// 显示分页
    public typealias xHandlerShowPage = (Int, UIViewController) -> Void
    
    // MARK: - IBOutlet Property
    /// 分段容器
    @IBOutlet weak var segmentContainer: xContainerView!
    /// 分页容器
    @IBOutlet weak var pageContainer: xContainerView!
    
    // MARK: - Open Property
    // MARK: - Public Property
    // MARK: - Private Property
    /// 分段
    let segment = xSegmentView.init()
    /// 分页
    let pageViewController = xPageViewController.quickInstancetype(navigationOrientation: .horizontal)
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
                       pageDataArray : [UIViewController])
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
                self.pageViewController.change(to: idx)
            }
            self.segment.updateSegmentStyle(choose: 0)
            // 加载分页数据
            self.pageViewController.reload(itemViewControllerArray: pageDataArray, isAddTapEvent: true) {
                (offset) in
                
            } change: {
                [unowned self] (page) in
                xLog(page)
                self.segment.updateSegmentStyle(choose: page)
                
            } click: {
                (page) in
                xLog(page)
            }
        }
    }
    
    // MARK: - Private Func

}
