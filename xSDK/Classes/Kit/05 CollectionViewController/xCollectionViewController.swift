//
//  xCollectionViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xCollectionViewController: UICollectionViewController {
    
    // MARK: - 数据源枚举
    /// 数据源枚举
    public enum DataTypeEnum {
        /// 普通、默认
        case normal
        /// 筛选
        case filter
    }
    
    // MARK: - 公有变量
    /// 控制器描述
    @IBInspectable public var xTitle : String = "控制器描述"
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isLoadRequestDataCompleted = true
    /// 是否是父控制器
    public var isRootParentViewController = false
    /// 数据源
    public var dataType = DataTypeEnum.normal
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
    
    // MARK: - 内存释放
    deinit {
        if self.isRootParentViewController {
            x_log("****************************")
        }
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("🥀_\(self.xTitle) \(name)")
    }
    
    // MARK: - 视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .groupTableViewBackground
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.registerHeaders()
        self.registerCells()
        self.registerFooters()
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
    
    // MARK: - 方法调用
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
    
    // MARK: - 方法重写
    /// 注册Headers
    open func registerHeaders() { }
    /// 注册Cells
    open func registerCells() { }
    /// 注册Footers
    open func registerFooters() { }
    /// 初始化UI
    open func initKit() { }
    /// 初始化子控制器
    open func initChildrenViewController() { }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open class func quickInstancetype() -> Self
    {
        let layout = UICollectionViewFlowLayout()
        let cvc = self.init(collectionViewLayout: layout)
        return cvc
    }
    required override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Collection view delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Scroll view delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset
        // 关闭顶部下拉
        if self.isCloseTopBounces {
            if (offset.y < 0) {
                offset.y = 0
                scrollView.bounces = false
            }
            else {
                scrollView.bounces = true
            }
            scrollView.contentOffset = offset
        }
        // 关闭底部上拉
        if self.isCloseBottomBounces {
            let maxOfy = scrollView.contentSize.height - scrollView.bounds.height - 1
            if (offset.y > maxOfy) {
                offset.y = maxOfy
                scrollView.bounces = false
            }
            else {
                scrollView.bounces = true
            }
            scrollView.contentOffset = offset
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.headerSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumInteritem
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionEdge
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
}
