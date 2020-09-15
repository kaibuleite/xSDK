//
//  View+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIView {
    
    // MARK: - Public Func
    // TODO: 锚点
    /// 重置锚点
    /// - Parameter anchorPoint: 新锚点
    public func x_reset(anchorPoint : CGPoint)
    {
        let origin_old = self.frame.origin
        self.layer.anchorPoint = anchorPoint
        let origin_new = self.frame.origin
        
        var center = self.center
        center.x -= (origin_new.x - origin_old.x)
        center.y -= (origin_new.y - origin_old.y)
        
        self.center = center
    }
    
    // TODO: 数据转换
    /// 将当前视图转为UIImage
    public func x_toImage() -> UIImage?
    {
        let frame = self.bounds
        let scale = UIScreen.main.scale
        // 绘画板
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
