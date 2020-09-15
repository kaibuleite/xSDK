//
//  Label+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UILabel
{
    /// 计算内容大小
    public func x_getContentSize() -> CGSize
    {
        guard self.numberOfLines == 0 else { return self.bounds.size }
        guard let str = self.text else { return self.bounds.size }
        let content = str as NSString
        let maxWidth = self.bounds.width
        let size = CGSize.init(width: maxWidth, height: 0)
        let frame = content.boundingRect(with: size,
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font : self.font!],
                                         context: nil)
        return frame.size
    }
}
