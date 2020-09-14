//
//  Double+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension Double {

    /// 转换成Double类型数据
    /// - Parameter precision: 最多保留小数点位数(默认保留2位)
    /// - Parameter clearMoreZero: 是否清除多余的0
    /// - Returns: 结果
    public func x_toString(precision : Int,
                           isClearMoreZero : Bool = true) -> String
    {
        let str = String.init(format: "%.\(precision)f", self)
        var ret = str
        guard isClearMoreZero == true else { return ret }
        guard ret.contains(".") == true else { return ret }
        // 带有小数，开始剔除
        let count = ret.count
        for _ in 0 ..< count {
            // 剔除末尾多余的0
            if ret.hasSuffix("0") {
                ret.removeLast()
            } else {
                break
            }
        }
        // 判断是否是整数
        if ret.hasSuffix(".") {
            ret.remove(at: ret.index(before: ret.endIndex))
        }
        if ret.count == 0 {
            ret = "0"
        }
        return ret
    }
    
}
