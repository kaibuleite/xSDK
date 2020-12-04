//
//  Image+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIImage {
    
    // MARK: - Public Func
    // TODO: 圆角图片
    /// 圆角图片
    /// - Parameter radius: 圆角半径
    /// - Returns: 新图片
    public func xToCorner(radius : CGFloat) -> UIImage?
    {
        let rect = CGRect.init(origin: .zero,
                               size: self.size)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 圆形图片
    public func xToCircle() -> UIImage?
    {
        let radius = fmin(self.size.width, self.size.height) / 2.0
        let rect = CGRect.init(x: self.size.width / 2.0 - radius,
                               y: self.size.height / 2.0 - radius,
                               width: 2.0 * radius,
                               height: 2.0 * radius)
        let path = UIBezierPath.init(roundedRect: rect,
                                     cornerRadius: radius)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    // TODO: 图片缩放
    /// 缩放图片(等比例)
    /// - Parameter size: 缩放大小
    /// - Returns: 新图片
    public func xToScale(size : CGSize) -> UIImage?
    {
        let factor_w = size.width / self.size.width
        let factor_h = size.height / self.size.height
        let factor = fmin(factor_w, factor_h)
        // 计算等比数据
        let w = self.size.width * factor
        let h = self.size.height * factor
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 根据宽度等比例缩放图片
    /// - Parameter width: 宽度
    /// - Returns: 新图片
    public func xToScale(width : CGFloat) -> UIImage?
    {
        let w = width
        // 计算等比数据
        let h = w * self.size.height / self.size.width
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 根据高度等比例缩放图片
    /// - Parameter height: 高度
    /// - Returns: 新图片
    public func xToScale(height : CGFloat) -> UIImage?
    {
        let h = height
        // 计算等比数据
        // 计算等比数据
        let w = h * self.size.width / self.size.height
        let size = CGSize.init(width: w,
                               height: h)
        let rect = CGRect.init(origin: .zero,
                               size: size)
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    // TODO: 图片压缩
    /// 压缩图片
    /// - Parameter size: 指定尺寸(kb)
    /// - Returns: 新图片
    public func xCompress(to size : CGFloat) -> Data?
    {
        // 原始大小
        var data = self.jpegData(compressionQuality: 1)
        guard size > 0 else { return data }
        
        var kb = CGFloat(data?.count ?? 0) / 1024
        var quality = CGFloat(1)
        var sub = CGFloat(0.05) // 每次递减
        while kb > size {
            if quality < sub { sub /= 2 }
            quality -= sub
            data = self.jpegData(compressionQuality: quality)
            kb = CGFloat(data?.count ?? 0) / 1024
        }
        return data
    }
    
    // TODO: 编辑图片
    /// 裁剪图片
    /// - Parameter rect: 剪范围裁
    /// - Returns: 新图片
    public func xToCut(rect : CGRect) -> UIImage?
    {
        let path = UIBezierPath.init(rect: rect)
        let ret = self.xDraw(rect: rect,
                             path: path)
        return ret
    }
    
    /// 拼接图片
    /// - Parameters:
    ///   - image: 要拼接的图片
    ///   - spacing: 是两张图片的间距,默认为0
    /// - Returns: 新图片
    public func xToAppend(image : UIImage,
                          spacing : Double = 0) -> UIImage?
    {
        let w = self.size.width + image.size.width + CGFloat(spacing)
        let h = fmax(self.size.height, image.size.height)
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: w, height: h), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
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
    public func xToCover(image : UIImage,
                         rect : CGRect) -> UIImage?
    {
        // 自身图片
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
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
    public func xToCoverCenter(image : UIImage) -> UIImage?
    {
        let x = (self.size.width - image.size.width) / 2.0
        let y = (self.size.height - image.size.height) / 2.0
        let center = CGPoint.init(x: x,
                                  y: y)
        let rect = CGRect.init(origin: center,
                               size: image.size)
        let ret = self.xToCover(image: image,
                                rect: rect)
        return ret
    }
    
    /// 转换成自适应方向图片
    public func xToFixOrientationImage() -> UIImage?
    {
        var transform = CGAffineTransform.identity
        let w = self.size.width
        let h = self.size.height
        // 根据图片方向调整方向——水平
        switch self.imageOrientation {
        case .up:
            return self
        case .down, .downMirrored:
            transform = transform.translatedBy(x: w, y: h)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: w, y: 0)
            transform = transform.rotated(by: .pi/2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: h)
            transform = transform.rotated(by: -.pi/2)
            break
        default:
            break
        }
        // 根据图片方向调整方向——垂直
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: w, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: h, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        // 重新渲染
        guard let cgImage = self.cgImage else { return nil }
        guard let colorSpace = cgImage.colorSpace else { return nil }
        let ctx = CGContext.init(data: nil,
                                 width: Int(w),
                                 height: Int(h),
                                 bitsPerComponent: cgImage.bitsPerComponent,
                                 bytesPerRow: cgImage.bytesPerRow,
                                 space: colorSpace,
                                 bitmapInfo: cgImage.bitmapInfo.rawValue,
                                 releaseCallback: nil,
                                 releaseInfo: nil)
        guard let context = ctx else { return nil }
        // 配置旋转样式
        context.concatenate(transform)
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: h, height: w))
        default:
            context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: w, height: h))
        }
        guard let retCGImage = context.makeImage() else { return nil }
        let ret = UIImage(cgImage: retCGImage) 
        return ret
    }
    
    // TODO: 数据转换
    /// 转换成 UIColor 类型数据
    public func xToColor() -> UIColor
    {
        let ret = UIColor.init(patternImage: self)
        return ret
    }
    
    // MARK: - Private Property
    /// 绘制图片
    /// - Parameters:
    ///   - rect: 绘制范围
    ///   - path: 绘制路径（裁剪路径）
    /// - Returns: 新图片
    private func xDraw(rect : CGRect,
                      path : UIBezierPath) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        ctx.addPath(path.cgPath)
        ctx.clip()
        self.draw(in: rect)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
