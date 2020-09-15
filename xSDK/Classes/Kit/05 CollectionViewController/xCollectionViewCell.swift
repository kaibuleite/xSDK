//
//  xCollectionViewCell.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Property
    /// 绑定的视图控制器
    weak var cvc : xCollectionViewController?
    
    // MARK: - 内存释放
    deinit {
        self.cvc = nil
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
