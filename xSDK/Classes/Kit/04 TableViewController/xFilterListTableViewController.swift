//
//  xFilterListTableViewController.swift
//  FDZK_Option
//
//  Created by Mac on 2020/10/12.
//

import UIKit

class xFilterListTableViewController: xListTableViewController {
    
    // MARK: - Enum
    /// 数据源枚举
    public enum xDataTypeEnum {
        /// 普通、默认
        case normal
        /// 筛选
        case filter
    }
    
    // MARK: - Public Property
    /// 数据源 类型
    public var dataType = xDataTypeEnum.normal
    /// 筛选数据源
    public var filterDataArray = [xModel]()
    /// 是否显示侧边导航栏
    public var isShowSideSectionTitle = true
    /// 侧边标题导航
    public var sideSectionTitleArray = [String]()
    
    // MARK: - Public Func
    /// 获取当前数据源
    public func getCurrentDataArray() -> [xModel]
    {
        switch self.dataType {
        case .normal:
            return self.dataArray
        case .filter:
            return self.filterDataArray
        }
    }
    
    /// 获取当前侧边导航标题源
    public func getCurrentSideSectionTitleArray() -> [String]
    {
        switch self.dataType {
        case .normal:
            return self.sideSectionTitleArray
        case .filter:
            return .init()
        }
    }
}

extension xFilterListTableViewController {
    
    /// 筛选数据源
    @objc open func filterDataArray(withKeyword str : String?)
    {
        defer {
            self.tableView.reloadData()
        }
        let keyword = str ?? ""
        self.dataType = .normal
        guard keyword.count > 0 else { return }
        self.dataType = .filter
        self.filterDataArray.removeAll()
        // 筛选数据 。。。
    }
}
