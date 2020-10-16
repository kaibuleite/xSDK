//
//  ImageView+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    // MARK: - Public Func
    /// 加载网络图片
    public func xRequest(url : String,
                         progress handler1 : ((Double) -> Void)? = nil,
                         completed handler2 : ((UIImage) -> Void)? = nil)
    {
        self.sd_setImage(with: url.xToURL(), placeholderImage: self.image, options: .retryFailed, progress: {
            (receivedSize, expectedSize, targetUrl) in
            guard let handler = handler1 else { return }
            let value = Double(receivedSize) / Double(expectedSize)
            handler(value)
        }, completed: {
            (image, error, cacheType, imageUrl) in
            guard let img = image else { return }
            guard let handler = handler2 else { return }
            handler(img)
        })
    }
    /// 设置为占位模式
    public func xSetPlaceholderMode()
    {
        self.image = nil
        self.backgroundColor = .groupTableViewBackground
    }
    /// 设置为普通模式
    public func xSetNormalMode()
    {
        self.backgroundColor = .clear
    }
}
