//
//  xCollectionViewCell.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Property
    /// 绑定的视图控制器
    public weak var cvc : xCollectionViewController?
    
    // MARK: - 内存释放
    deinit {
        self.cvc = nil
    }
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Open Func
    /// 设置内容数据
    open func setContentData(with model : xModel)
    {
        
    }
    /// 设置内容图片
    open func setContentImage(with model : xModel)
    {
        
    }
}
