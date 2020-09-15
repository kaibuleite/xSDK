//
//  xListCollectionViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import MJRefresh

class xListCollectionViewController: UICollectionViewController {
    
    // MARK: - 公有变量
    /// 分页数据
    public var page = xPage()
    /// 数据源
    public var dataArray = [xModel]()
    /// 空数据展示图
    public var dataEmptyView : UIView?
    
    // MARK: - 视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // 主线程执行(方便在子类的 viewDidLoad 里设置部分参数)
            self.addMJRefresh()
        }
    }
    
    // MARK: - 刷新Header
    /// 添加头部刷新
    open func addHeaderRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self,
                                                refreshingAction: #selector(refreshHeader))
        self.collectionView.mj_header = header
    }
    /// 刷新头部
    @objc public func refreshHeader() {
        self.page.current = 1
        self.refreshDataList()
    }
    
    // MARK: - 刷新Footer
    /// 添加尾部刷新
    open func addFooterRefresh() {
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self,
                                                    refreshingAction: #selector(refreshFooter))
        self.collectionView.mj_footer = footer
    }
    /// 刷新尾部
    @objc public func refreshFooter() {
        self.page.current += 1
        self.refreshDataList()
    }
    
    // MARK: - 方法调用
    /// 数据刷新成功
    public func refreshSuccess()
    {
        self.collectionView.mj_header?.endRefreshing()
        if self.page.isMore {
            self.collectionView.mj_footer?.endRefreshing()
        }
        else {
            self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    /// 数据刷新失败
    public func refreshFailure()
    {
        self.collectionView.mj_header?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshing()
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
        self.collectionView.reloadData()
        // 显示空数据提示视图
        self.dataEmptyView?.removeFromSuperview()
        guard self.dataArray.count == 0 else { return }
        guard let emptyView = self.loadEmptyView() else { return }
        self.dataEmptyView = emptyView
        self.collectionView.addSubview(emptyView)
    }
    
    // MARK: - 方法重写
    /// 添加刷新
    open func addMJRefresh() { }
    /// 刷新数据
    open func refreshDataList() {
        // 模拟数据
        let list = xModel.newList()
        self.refreshSuccess()
        self.reloadData(list: list)
    }
    /// 空数据展示图
    open func loadEmptyView() -> UIView? { return nil }
}
