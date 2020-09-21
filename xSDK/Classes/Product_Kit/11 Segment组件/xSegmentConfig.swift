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
    public var itemNormalTitleColor = UIColor.darkText
    /// 普通背景颜色
    public var itemNormalBackgroundColor = UIColor.clear
    /// 普通边框颜色
    public var itemNormalBorderColor = UIColor.clear
    
    /// 选中标题颜色
    public var itemChooseTitleColor = UIColor.red
    /// 选中背景颜色
    public var itemChooseBackgroundColor = UIColor.clear
    /// 选中边框颜色
    public var itemChooseBorderColor = UIColor.clear
    
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
