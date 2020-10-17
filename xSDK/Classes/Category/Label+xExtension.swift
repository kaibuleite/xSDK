//
//  Label+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UILabel {
    
    // MARK: - Public Func
    /// 计算内容大小
    public func xGetContentSize() -> CGSize
    {
        guard let str = self.text else { return self.bounds.size }
        let nstr = str as NSString
        let maxWidth = self.bounds.width
        let size = CGSize.init(width: maxWidth, height: 0)
        let frame = nstr.boundingRect(with: size,
                                      options: .usesLineFragmentOrigin,
                                      attributes: [.font : self.font!],
                                      context: nil)
        return frame.size
    }
    /// 设置为占位模式
    public func xSetPlaceholderMode(string : String = "     ")
    {
        self.text = string
        self.backgroundColor = xAppManager.shared.placeholderBackgroundColor
    }
    /// 设置为普通模式
    public func xSetNormalMode()
    {
        self.backgroundColor = .clear
    }
}
