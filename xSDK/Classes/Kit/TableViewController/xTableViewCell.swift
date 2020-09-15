//
//  xTableViewCell.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xTableViewCell: UITableViewCell {
    
    // MARK: - 公有变量
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
