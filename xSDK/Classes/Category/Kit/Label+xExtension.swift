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
    /// - Parameters:
    ///   - margin: 边缘留空
    /// - Returns: 内容大小
    public func xGetContentSize(margin : UIEdgeInsets = .zero) -> CGSize
    {
        guard let str = self.text else { return self.bounds.size }
        guard str.count > 0 else { return self.bounds.size }
        var w = self.bounds.width
        var h = self.bounds.height
        if w <= 0 { w = xScreenWidth }
        if h <= 0 { h = xScreenHeight }
        var size = str.xGetSize(for: self.font,
                                size: .init(width: w, height: h))
        size.width += (margin.left + margin.right)
        size.height += (margin.top + margin.bottom)
        return size
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
