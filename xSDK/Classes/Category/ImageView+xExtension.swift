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
                         completed handler : SDExternalCompletionBlock? = nil)
    {
        self.sd_setImage(with: url.xToURL(),
                         placeholderImage: nil,
                         options: .retryFailed,
                         completed: handler)
    }
}
