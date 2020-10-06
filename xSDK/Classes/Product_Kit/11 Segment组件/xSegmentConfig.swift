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
