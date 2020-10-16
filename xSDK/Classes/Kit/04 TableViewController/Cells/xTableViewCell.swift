//
//  xTableViewCell.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xTableViewCell: UITableViewCell {
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Open Func
    /// 设置内容占位数据
    open func setContentPlaceholderData()
    {
        /*
        UIImageView.init().xSetPlaceholderMode()
        UILabel.init().xSetPlaceholderMode()()
         */
    }
    /// 设置内容数据
    open func setContentData(with model : xModel)
    {
        /*
        UIImageView.init().xSetNormalMode()()
        UILabel.init().xSetNormalMode()
        */
    }
    /// 添加按钮事件
    open func addBtnClickHandler(in xtvc : xTableViewController)
    {
        /*
        guard let tvc = xtvc as? <#xTableViewController#> else { return }
        UIButton.init().xAddClick {
            (sender) in
            
        }*/
    }
}
