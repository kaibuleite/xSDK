//
//  xGPasswordConfig.swift
//  xSDK
//
//  Created by Mac on 2020/10/6.
//

import UIKit

// MARK: - 手势密码配置
public class xGPasswordLineConfig: NSObject {
    
    /// 线宽
    public var lineWidth = CGFloat(6)
    /// 线颜色
    public var lineColor = UIColor.xNew(hex: "0075E3")
}

// MARK: - 手势密码结果配置
public class xGPasswordResultConfig: NSObject {
    
    /// 点半径
    public var pointRadius = CGFloat(2.5)
    /// 点颜色
    public var pointColor = UIColor.groupTableViewBackground
    /// 线宽
    public var lineWidth = CGFloat(1.5)
    /// 线颜色
    public var lineColor = UIColor.groupTableViewBackground
}

// MARK: - 手势密码点配置
public class xGPasswordPointConfig: NSObject {
    
    /// 内部半径
    public var interRadius = CGFloat(10)
    
    /// 内部普通边框颜色
    public var interStrokeNromalColor = UIColor.clear
    /// 内部选中边框颜色
    public var interStrokeChooseColor = UIColor.clear
    /// 内部普通填充颜色
    public var interFillNormalColor = UIColor.groupTableViewBackground
    /// 内部选中填充颜色
    public var interFillChooseColor = UIColor.xNew(hex: "0075E3")
    
    /// 点外部半径
    public var outerRadius = CGFloat(20)
    /// 外部普通边框颜色
    public var outerStrokeNromalColor = UIColor.clear
    /// 外部选中边框颜色
    public var outerStrokeChooseColor = UIColor.xNew(hex: "0075E3")
    /// 外部普通填充颜色
    public var outerFillNormalColor = UIColor.clear
    /// 外部选中填充颜色
    public var outerFillChooseColor = UIColor.clear
    
    /// 箭头颜色
    public var arrowColor = UIColor.xNew(hex: "0075E3")
    /// 边长
    public var arrowLength = CGFloat(15)
    /// 间距
    public var arrowMargin = CGFloat(8)
}
