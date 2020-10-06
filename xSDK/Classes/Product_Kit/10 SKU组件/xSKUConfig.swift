//
//  xSKUConfig.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xSKUConfig: NSObject {

    // MARK: - Public Property
    /// 普通标题颜色
    public var itemTitleNormalColor = UIColor.darkText
    /// 选中标题颜色
    public var itemTitleChooseColor = UIColor.red
    
    /// 普通背景颜色
    public var itemBackgroundNormalColor = UIColor.clear
    /// 选中背景颜色
    public var itemBackgroundChooseColor = UIColor.clear
    
    /// 普通边框颜色
    public var itemBorderNormalColor = UIColor.clear
    /// 选中边框颜色
    public var itemBorderChooseColor = UIColor.clear
    
    /// 行间距
    public var rowSpacing = CGFloat(0)
    /// 列间距
    public var columnSpacing = CGFloat(0)
    /// item指定高度(默认44)
    public var itemHeight = CGFloat(44)
    
    /// 圆角半径(默认0)
    public var cornerRadius = CGFloat.zero
    /// 边框线宽
    public var borderWidth = CGFloat.zero
    
    /// 字号(默认15.0)
    public var fontSize = CGFloat(15)
}
