//
//  xCollectionViewCell.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Open Func
    /// 设置内容数据
    open func setContentData(with model : xModel)
    {
        /* 设置缓存图片
        let icon = UIImageView.init()
        let imgurl = ""
        if let img = xAppManager.getSDCacheImage(forKey: imgurl) {
            icon.image = img
        } else {
            icon.image = xAppManager.shared.placeholderImage
        } */
    }
    /// 设置滚动结束后中内容数据（一般放下载图片，需要设置tvc的 isOpenReloadDragScrollingEndVisibleCells = true）
    open func setDragScrollingEndContentData(with model : xModel)
    {
        /* 异步下载图片（该方法会在scrollview停止滚动后才调用，优化性能
        let icon = UIImageView.init()
        let imgurl = ""
        icon.sd_setImage(with: imgurl.xToURL(), placeholderImage: xAppManager.shared.placeholderImage, options: .retryFailed, completed: nil)
         */
    }
    /// 添加按钮事件
    open func addBtnClickHandler(in xcvc : xCollectionViewController,
                                 model : xModel)
    {
    }
}
