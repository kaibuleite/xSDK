//
//  xDynamicPoint.swift
//  xSDK
//
//  Created by Mac on 2020/12/1.
//

import UIKit

class xDynamicPoint: NSObject {
    
    // MARK: - Public Property
    /// x坐标
    var x = CGFloat.zero
    /// y坐标
    var y = CGFloat.zero
    /// 半径
    var r = CGFloat(2)
    /// x坐标偏移量（决定速度）
    var offsetX = CGFloat.zero
    /// y坐标偏移量（决定速度）
    var offsetY = CGFloat.zero
    
    // MARK: - Public Func
    /// 随机点
    static func randomPoint() -> xDynamicPoint
    {
        let point = xDynamicPoint.init()
        point.x = xRandomBetween(min: 0, max: xScreenWidth)
        point.y = xRandomBetween(min: 0, max: xScreenHeight)
        point.r = xRandomBetween(min: 2, max: 3)
        point.offsetX = point.getRandomOffsetValue()
        point.offsetY = point.getRandomOffsetValue()
        return point
    }
    /// Point值
    func toPoint() -> CGPoint
    {
        return CGPoint.init(x: self.x, y: self.y)
    }
    
    /// 更新坐标
    func updateOrigin()
    {
        self.x += self.offsetX
        self.y += self.offsetY
        // 边界处理
        if (self.x > xScreenWidth) {
            self.offsetX = -1 * abs(self.getRandomOffsetValue())
            self.x += self.offsetX
        }
        else
        if (self.x < 0) {
            self.offsetX = abs(self.getRandomOffsetValue())
            self.x += self.offsetX
        }
        
        if (self.y > xScreenHeight) {
            self.offsetY = -1 * abs(self.getRandomOffsetValue())
            self.y += self.offsetY
        }
        else
        if (self.y < 0) {
            self.offsetY = abs(self.getRandomOffsetValue())
            self.y += self.offsetY
        }
    }
    
    // MARK: - Private Func
    /// 获取随机偏移值
    private func getRandomOffsetValue() -> CGFloat
    {
        let ret = CGFloat(xRandomBetween(min: -10, max: 10) / 40)
        return ret
    }
}
