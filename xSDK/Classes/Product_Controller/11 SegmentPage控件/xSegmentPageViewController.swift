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
    let pageViewController = xPageViewController.quickInstancetype()
    /// 回调
    var showHandler : xHandlerShowPage?
    
    // MARK: - 内存释放
    deinit {
        self.showHandler = nil
    }
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func addKit() {
        self.segment.frame = self.segmentContainer.bounds
        self.segmentContainer.addSubview(self.segment)
    }
    open override func addChildren() {
        self.xAddChild(self.pageViewController, in: self.pageContainer)
    }
    
    // MARK: - Public Func
    public func reload(titleArray : [String],
                       fillMode : xSegmentConfig.xSegmentItemFillMode = .fillEqually,
                       pageArray : [UIViewController])
    {
        self.segment.reload(titleArray: titleArray, fillMode: fillMode) {
            (idx) in
            xLog(titleArray[idx])
        }
        self.pageViewController.reload(itemViewControllerArray: pageArray, isAddTapEvent: true) {
            (offset) in
            
        } change: {
            (page) in
            
        } click: {
            (page) in
            
        }
    }
    
    // MARK: - Private Func

}
