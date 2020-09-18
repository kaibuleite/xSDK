//
//  xTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xTableViewController: UITableViewController {
    
    // MARK: - Enum
    /// 数据源枚举
    public enum xDataTypeEnum {
        /// 普通、默认
        case normal
        /// 筛选
        case filter
    }
    
    // MARK: - IBInspectable Property
    /// 控制器描述
    @IBInspectable
    public var xTitle : String = ""
    
    // MARK: - Public Property
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isLoadRequestDataCompleted = true
    /// 是否是父控制器
    public var isRootParentViewController = false
    /// 数据源
    public var dataType = xDataTypeEnum.normal
    /// 是否关闭顶部下拉回弹
    public var isCloseTopBounces = false
    /// 是否关闭底部上拉回弹
    public var isCloseBottomBounces = false
    
    // MARK: - 内存释放
    deinit {
        if self.isRootParentViewController {
            x_log("****************************")
        }
        guard let name = x_getClassName(withObject: self) else { return }
        x_log("🍂 \(self.xTitle) \(name)")
    }
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = xAppManager.shared.tableViewBackgroundColor
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.keyboardDismissMode = .onDrag
        // 默认自动计算长度
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        // self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = 44
        
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
    
    // MARK: - Open Func
    /// 注册Headers
    open func registerHeaders() { }
    /// 注册Cells
    open func registerCells() { }
    /// 注册Footers
    open func registerFooters() { }
    /// 初始化UI
    open func addKit() { }
    /// 初始化子控制器
    open func addChildren() { }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    open class func quickInstancetype() -> Self
    {
        let tvc = self.init(style: UITableView.Style.grouped)
        return tvc
    }
    required public override init(style: UITableView.Style) {
        super.init(style: style)
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
        self.tableView.register(nib,
                                forCellReuseIdentifier: identifier)
    }
    /// 注册ClassCell
    /// - Parameters:
    ///   - nibName: xib名称
    ///   - identifier: 重用符号
    public func register(cellClass : AnyClass?,
                        identifier : String)
    {
        self.tableView.register(cellClass,
                                forCellReuseIdentifier: identifier)
    }
    
    // MARK: - Table view delegate
    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Scroll view delegate
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
}
