//
//  Array+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit

extension Array {

    // MARK: - Public Func
    /// 获取数组中指定数据的编号（仅支持NSObject相关对象）
    /// - Parameters:
    ///   - object: 要查找的对象数据
    /// - Returns: 编号
    public func xIndex(with object : AnyObject) -> Int?
    {
        for (i, element) in self.enumerated() {
            let obj = element as AnyObject
            if obj.isEqual(object) {
                return i
            }
        }
        return nil
    }
}
