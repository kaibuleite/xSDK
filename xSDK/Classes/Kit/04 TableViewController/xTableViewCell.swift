//
//  xTableViewCell.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xTableViewCell: UITableViewCell {
    
    // MARK: - Public Property
    /// 绑定的视图控制器
    public weak var tvc : xTableViewController?
    
    // MARK: - 内存释放
    deinit {
        self.tvc = nil
    }
    
    // MARK: - 视图加载
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - 设置内容数据
    /// 设置内容数据
    open func setContentData(with model : xModel)
    {
        
    }
}
