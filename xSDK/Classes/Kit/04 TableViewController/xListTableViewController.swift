//
//  xListTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import MJRefresh

open class xListTableViewController: xTableViewController {
    
    // MARK: - Public Property
    /// 分页数据
    public let page = xPage()
    /// 数据源
    public var dataArray = [xModel]()
    /// 空数据展示图
    public var dataEmptyView : UIView?
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // 主线程执行(方便在子类的 viewDidLoad 里设置部分参数)
            self.addMJRefresh()
        }
    }
    
    // MARK: - Public Func
    /// 刷新头部
    @objc public func refreshHeader()
    {
        self.page.current = 1
        self.refreshDataList()
    }
    /// 刷新尾部
    @objc public func refreshFooter()
    {
        self.page.current += 1
        self.refreshDataList()
    }
    /// 数据刷新成功
    public func refreshSuccess()
    {
        self.tableView.mj_header?.endRefreshing()
        if self.page.isMore {
            self.tableView.mj_footer?.endRefreshing()
        }
        else {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    /// 数据刷新失败
    public func refreshFailure()
    {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }
    /// 拼接数据源
    /// - Parameter list: 新的数据
    public func reloadData(list : [xModel])
    {
        if self.page.current <= 1 {
            self.dataArray = list
        }
        else {
            self.dataArray.append(contentsOf: list)
        }
        self.tableView.reloadData()
        // 显示空数据提示视图
        self.dataEmptyView?.removeFromSuperview()
        guard self.dataArray.count == 0 else { return }
        guard let emptyView = self.getEmptyView() else { return }
        self.dataEmptyView = emptyView
        self.tableView.addSubview(emptyView)
    }
}

// MARK: - Extension
extension xListTableViewController {
    
    /// 添加刷新
    @objc open func addMJRefresh() { }
    /// 添加头部刷新
    @objc open func addHeaderRefresh()
    {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self,
                                                refreshingAction: #selector(refreshHeader))
        self.tableView.mj_header = header
    }
    /// 添加尾部刷新
    @objc open func addFooterRefresh()
    {
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self,
                                                    refreshingAction: #selector(refreshFooter))
        self.tableView.mj_footer = footer
    }
    /// 刷新数据
    @objc open func refreshDataList() {
        // 模拟数据
        let list = xModel.newRandomList()
        self.refreshSuccess()
        self.reloadData(list: list)
    }
    /// 空数据展示图
    @objc open func getEmptyView() -> UIView? {
        var frame = self.tableView.bounds
        frame.origin.y = self.tableView.sectionHeaderHeight
        frame.size.width -= self.tableView.sectionHeaderHeight
        frame.size.width -= self.tableView.sectionFooterHeight
        let view = xDataEmptyView.loadNib()
        view.frame = frame
        return view
    }
}
