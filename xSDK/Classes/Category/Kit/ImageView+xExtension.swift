//
//  ImageView+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit

extension UIImageView {
    
    // MARK: - Public Func
    /// 加载网络图片
    public func xSetWebImage(url : String,
                             placeholderImage : UIImage? = xAppManager.shared.placeholderImage,
                             completed : (() -> Void)? = nil)
    {
        var str = url
        if url.hasPrefix("http") == false {
            str = xAppManager.shared.webImageURLPrefix + url
        }
        // 先解码再编码，防止URL已经编码导致2次编码
        str = str.xToUrlDecodeString() ?? str
        str = str.xToUrlEncodeString() ?? str
        self.sd_setImage(with: str.xToURL(), placeholderImage: placeholderImage, options: .retryFailed) {
            (img, err, _, _) in
            completed?()
        }
    }
}
