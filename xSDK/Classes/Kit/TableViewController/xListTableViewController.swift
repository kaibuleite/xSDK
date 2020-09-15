//
//  xListTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xListTableViewController: xTableViewController {
    
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
            //self.addMJRefresh()
        }
    }
    
    
    
    
    
    
    
    // MARK: - 子类重写
    /// 空数据展示图
    open func emptyView() -> UIView {
        let view = UIView()
        view.backgroundColor = .x_random()
        return view
    }
}
