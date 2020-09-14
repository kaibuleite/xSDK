//
//  Image+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIImage
{
    // MARK: - 绘制图片
    /// 绘制图片
    /// - Parameters:
    ///   - rect: 绘制范围
    ///   - path: 绘制路径（裁剪路径）
    /// - Returns: 新图片
    public func x_draw(rect : CGRect,
                       path : UIBezierPath) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, false,
                                               self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        context?.clip()
        self.draw(in: rect)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    /// 圆角图片
    /// - Parameter radius: 圆角半径
    /// - Returns: 新图片
    public func x_draw(radius : CGFloat) -> UIImage?
    {
        let rect = CGRect.init(origin: .zero,
                               size: self.size)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    /// 裁剪图片
    /// - Parameter rect: 剪范围裁
    /// - Returns: 新图片
    public func x_cut(rect : CGRect) -> UIImage?
    {
        let path = UIBezierPath.init(rect: rect)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    /// 圆形图片
    public func x_toCircleImage() -> UIImage?
    {
        let radius = fmin(self.size.width, self.size.height) / 2.0
        let rect = CGRect.init(x: self.size.width / 2.0 - radius,
                               y: self.size.height / 2.0 - radius,
                               width: 2.0 * radius,
                               height: 2.0 * radius)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    
    // MARK: - 图片缩放
    /// 缩放图片(等比例)
    /// - Parameter size: 缩放大小
    /// - Returns: 新图片
    public func x_scale(size : CGSize) -> UIImage?
    {
        let factor_w = size.width / self.size.width
        let factor_h = size.height / self.size.height
        let factor = fmin(factor_w, factor_h)
        // 计算等比数据
        let w = self.size.width * factor * self.scale
        let h = self.size.height * factor * self.scale
        let rect = CGRect.init(x: 0,
                               y: 0,
                               width: w,
                               height: h)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    /// 根据宽度等比例缩放图片
    /// - Parameter width: 宽度
    /// - Returns: 新图片
    public func x_scale(width : CGFloat) -> UIImage?
    {
        let w = width
        let h = w * self.size.height / self.size.width
        // 计算等比数据
        let rect = CGRect.init(x: 0,
                               y: 0,
                               width: w,
                               height: h)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    /// 根据高度等比例缩放图片
    ///
    /// - Parameter height: 高度
    /// - Returns: 缩放后的图片
    public func x_scale(height : CGFloat) -> UIImage?
    {
        let h = height
        let w = h * self.size.width / self.size.height
        // 计算等比数据
        let rect = CGRect.init(x: 0,
                               y: 0,
                               width: w,
                               height: h)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.x_draw(rect: rect,
                              path: path)
        return ret
    }
    
    // MARK: - 图片拼接
    /// 拼接图片
    /// - Parameters:
    ///   - image: 要拼接的图片
    ///   - spacing: 是两张图片的间距,默认为0
    /// - Returns: 新图片
    public func x_append(image : UIImage,
                         spacing : Double = 0) -> UIImage?
    {
        let w = self.size.width + image.size.width + CGFloat(spacing)
        let h = fmax(self.size.height, image.size.height)
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: w, height: h), false, self.scale)
        var rect = CGRect.init()
        rect.origin.y = (h - self.size.height) / 2.0
        rect.size = self.size
        self.draw(in: rect)
        // 要拼接的图片
        rect.origin.x = self.size.width + CGFloat(spacing)
        rect.origin.y = (h - image.size.height) / 2.0
        rect.size = image.size
        image.draw(in: rect)
        // 拼接
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    /// 覆盖图片
    /// - Parameters:
    ///   - image: 要覆盖的图片
    ///   - rect: 大小、位置
    /// - Returns: 新图片
    public func x_add(image : UIImage,
                      rect : CGRect) -> UIImage?
    {
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect.init(origin: CGPoint.zero, size: self.size))
        image.draw(in: rect)
        // 要覆盖的图片
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    /// 覆盖图片到自己中心
    /// - Parameter image: 要覆盖的图片
    /// - Returns: 新图片
    public func x_addCenter(image : UIImage) -> UIImage?
    {
        let x = (self.size.width - image.size.width) / 2.0
        let y = (self.size.height - image.size.height) / 2.0
        let rect = CGRect.init(x: x,
                               y: y,
                               width: image.size.width,
                               height: image.size.height)
        let ret = self.x_add(image: image,
                             rect: rect)
        return ret
    }
    
    // MARK: - 数据转换
    /// 转换成 UIColor 类型数据
    public func x_toColor() -> UIColor
    {
        let ret = UIColor.init(patternImage: self)
        return ret
    }
}
