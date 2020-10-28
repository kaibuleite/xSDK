//
//  xSegmentConfig.swift
//  xSDK
//
//  Created by Mac on 2020/9/16.
//

import UIKit

public class xSegmentConfig: NSObject {
    
    // MARK: - Public Property
    /// 普通标题颜色
    public var itemTitleNormalColor = UIColor.darkText
    /// 普通背景颜色
    public var itemBackgroundNormalColor = UIColor.clear
    /// 普通边框颜色
    public var itemBorderNormalColor = UIColor.clear
    
    /// 选中标题颜色
    public var itemTitleChooseColor = UIColor.red
    /// 选中背景颜色
    public var itemBackgroundChooseColor = UIColor.clear
    /// 选中边框颜色
    public var itemBorderChooseColor = UIColor.clear
    
    /// 边框线宽
    public var borderWidth = CGFloat(0)
    /// 圆角
    public var cornerRadius = CGFloat(0)
    
    /// 间隔
    public var itemsMargin = CGFloat(0)
    
    /// 线高(默认2)
    public var lineHeight = CGFloat(2)
    /// 线条颜色
    public var lineColor = UIColor.red
}

public class xSegmentConfigNew: NSObject {
    
    /// 颜色数据结构
    public struct xSegmentItemColor {
        /// 普通
        public var normal = UIColor.darkText
        /// 选中
        public var choose = UIColor.red
    }
    /// 边框数据结构
    public struct xSegmentItemBorder {
        /// 边框颜色
        public var color = xSegmentItemColor.init(normal: .clear, choose: .clear)
        /// 线宽
        public var lineWidth = CGFloat.zero
        /// 圆角
        public var cornerRadius = CGFloat(0)
    }

    /// 标题颜色
    public var titleColor = xSegmentItemColor.init(normal: .lightGray, choose: .darkText)
    /// 背景颜色
    public var backgroundColor = xSegmentItemColor.init(normal: .clear, choose: .clear)
    /// 边框样式
    public var border = xSegmentItemBorder.init()
    /// 间距
    public var spacing = CGFloat.zero
    /// 分布类型
    public var distribution = UIStackView.Distribution.fillEqually
}
