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
