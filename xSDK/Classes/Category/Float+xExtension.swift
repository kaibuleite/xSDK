//
//  Float+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension Float {
    
    // MARK: - Public Func
    /// 转换成Double类型数据
    /// - Parameter precision: 最多保留小数点位数(默认保留2位)
    /// - Parameter clearMoreZero: 是否清除多余的0
    /// - Returns: 结果
    public func xToString(precision : Int,
                          isClearMoreZero : Bool = true) -> String
    {
        let db = Double(self)
        let ret = db.xToString(precision: precision,
                                isClearMoreZero: isClearMoreZero)
        return ret
    }
    
}

extension CGFloat {
    
    // MARK: - Public Property
    /// 数据转换，对应设计图中宽度750的值
    public var xToDesign750Value : CGFloat
    {
        let ret = self / 750 * xScreenWidth
        return ret
    }
}
