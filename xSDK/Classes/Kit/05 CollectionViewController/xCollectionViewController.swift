//
//  xCollectionViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xCollectionViewController: UICollectionViewController {
    
    // MARK: - Handler
    /// 滚动开始回调
    public typealias xHandlerScrollViewChangeStatus = (CGPoint) -> Void
    
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
    /// 是否关闭顶部下拉回弹
    public var isCloseTopBounces = false
    /// 是否关闭底部上拉回弹
    public var isCloseBottomBounces = false
    
    /// 头部大小
    public var headerSize = CGSize.zero
    /// item大小
    public var itemSize = CGSize.zero
    /// 空白填充
    public var sectionEdge = UIEdgeInsets.zero
    /// 行缩进
    public var minimumLineSpacing = CGFloat.zero
    /// 列缩进
    public var minimumInteritem = CGFloat.zero
    
    // MARK: - Private Property
    /// 拖拽标识
    var isScrolling = false
    /// 滚动开始回调
    var beginScrollHandler : xHandlerScrollViewChangeStatus?
    /// 滚动中回调
    var scrollingHandler : xHandlerScrollViewChangeStatus?
    /// 滚动完成回调
    var endScrollHandler : xHandlerScrollViewChangeStatus?
    
    // MARK: - 内存释放
    deinit {
        self.beginScrollHandler = nil
        self.scrollingHandler = nil
        self.endScrollHandler = nil
        if self.isRootParentViewController {
            xLog("****************************")
        }
        xLog("🥀 \(self.xTitle) \(self.xClassStruct.name)")
    }
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = xAppManager.shared.tableViewBackgroundColor
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.registerHeaders()
        self.registerCells()
        self.registerFooters()
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
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open override class func quickInstancetype() -> Self
    {
        let layout = UICollectionViewFlowLayout()
        let cvc = self.init(collectionViewLayout: layout)
        return cvc
    }
    required public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Func
    /// 注册NibCell
    /// - Parameters:
    ///   - name: xib名称
    ///   - identifier: 重用符号
    public func register(nibName : String,
                         bundle : Bundle? = nil,
                         identifier : String)
    {
        let nib = UINib.init(nibName: nibName,
                             bundle: bundle)
        self.collectionView.register(nib,
                                     forCellWithReuseIdentifier: identifier)
    }
    /// 注册ClassCell
    /// - Parameters:
    ///   - nibName: xib名称
    ///   - identifier: 重用符号
    public func register(cellClass : AnyClass?,
                         identifier : String)
    {
        self.collectionView.register(cellClass,
                                     forCellWithReuseIdentifier: identifier)
    }
    /// 添加开始滚动回调
    public func addBeginScrollHandler(_ handler : @escaping xHandlerScrollViewChangeStatus)
    {
        self.beginScrollHandler = handler
    }
    /// 添加滚动中回调
    public func addScrollingHandler(_ handler : @escaping xHandlerScrollViewChangeStatus)
    {
        self.scrollingHandler = handler
    }
    /// 添加滚动完成回调
    public func addEndScrollHandler(_ handler : @escaping xHandlerScrollViewChangeStatus)
    {
        self.endScrollHandler = handler
    }
    
    // MARK: - Private Func
    /// 滚动结束
    private func scrollEnd(_ scrollView: UIScrollView)
    {
        self.isScrolling = false
        // 设置显示的Cell的图片(一般在滚动结束后再设置，降低图片渲染的开销)
        for cell in self.collectionView.visibleCells {
            guard let xCell = cell as? xCollectionViewCell else { continue }
            guard let idp = self.collectionView.indexPath(for: cell) else { continue }
            // 数据填充
            if let model = self.getCellDataModel(at: idp) {
                xCell.setContentData(with: model)
            }
            // 事件响应
            xCell.addBtnClickHandler(in: self)
        }
        // 执行回调
        self.endScrollHandler?(scrollView.contentOffset)
    }
    
    // MARK: - Collection view delegate
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Scroll view delegate
    /* 开始拖拽 */
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
        self.beginScrollHandler?(scrollView.contentOffset)
    }
    /* 开始减速 */
    open override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    /* 滚动中 */
    open override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset
        // 关闭顶部下拉
        if self.isCloseTopBounces {
            scrollView.bounces = true
            if (offset.y < 0) {
                offset.y = 0
                scrollView.bounces = false
            }
            scrollView.contentOffset = offset
        }
        // 关闭底部上拉
        if self.isCloseBottomBounces {
            scrollView.bounces = true
            let maxOfy = scrollView.contentSize.height - scrollView.bounds.height - 1
            if (offset.y > maxOfy) {
                offset.y = maxOfy
                scrollView.bounces = false
            }
            scrollView.contentOffset = offset
        }
    }
    /* 停止拖拽*/
    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 停止后有减速惯性，继续滚动
        guard !decelerate else { return }
        xLog("\n***** 1.没有减速惯性，直接停止滚动")
        self.scrollEnd(scrollView)
    }
    /* 滚动完毕就会调用（人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.isScrolling else { return }
        // MJRefresh刷新时不调用
        if let header = self.collectionView.mj_header {
            guard header.isRefreshing == false else { return }
        }
        if let footer = self.collectionView.mj_footer {
            guard footer.isRefreshing == false else { return }
        }
        let ofy = scrollView.contentOffset.y
        if self.isCloseTopBounces == false {
            // 开启下拉回弹
            guard ofy >= -1 else { return }
        }
        if self.isCloseBottomBounces == false {
            // 关闭上拉回弹
            guard ofy <= scrollView.contentSize.height - scrollView.bounds.height + 1 else { return }
        }
        xLog("\n***** 2.减速惯性消失，停止滚动")
        self.scrollEnd(scrollView)
    }
    /* 滚动完毕就会调用（不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）*/
    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        xLog("\n***** 3.代码动画结束，停止滚动滚动3")
        self.scrollEnd(scrollView)
    }
    /* 调整内容插页，配合MJ_Header使用 */
    open override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        var isAddMJKit = false // 是否添加了MFRefresh控件
        if let header = self.collectionView.mj_header {
            isAddMJKit = true
            guard header.isRefreshing == false else { return }
        }
        if let footer = self.collectionView.mj_footer {
            isAddMJKit = true
            guard footer.isRefreshing == false else { return }
        }
        // 没有搭载MFRefresh控件无需处理
        guard isAddMJKit == true else { return }
        // 停止滚动
        xLog("\n***** 4.MJRefresh动画结束，停止滚动")
        self.scrollEnd(scrollView)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.headerSize
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumInteritem
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionEdge
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
}

// MARK: - Extension Func
extension xCollectionViewController {
    
    /// 注册Headers
    @objc open func registerHeaders() { }
    /// 注册Cells
    @objc open func registerCells() { }
    /// 注册Footers
    @objc open func registerFooters() { }
    /// 获取指定idp的数据model（如果不需要设置数据可以返回nil）
    /// - Parameter idp: IndexPath
    /// - Returns: 数据对象
    @objc open func getCellDataModel(at idp : IndexPath) -> xModel?
    {
        return nil
    }
}
