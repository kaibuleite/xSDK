//
//  Color+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIColor {
    
    // MARK: - Public Func
    // TODO: 实例化新颜色
    /// 创建16进制色
    /// - Parameters:
    ///   - hex: 16进制内容
    ///   - alpha: 透明度
    /// - Returns: 新颜色
    public static func xNew(hex : String,
                            alpha : CGFloat = 1) -> UIColor
    {
        var str = hex
        // 去掉16进制中开头的无用字符
        str = str.replacingOccurrences(of: "0X", with: "")
        str = str.replacingOccurrences(of: "0x", with: "")
        str = str.replacingOccurrences(of: "#", with: "")
        if str.count == 3 {
            let rStr = str.xSub(range: NSMakeRange(0, 1)) ?? "0"
            let gStr = str.xSub(range: NSMakeRange(1, 1)) ?? "0"
            let bStr = str.xSub(range: NSMakeRange(2, 1)) ?? "0"
            str = rStr + rStr + gStr + gStr + bStr + bStr
        }
        else
        if str.count != 6 {
            xWarning("要转换的16进制字符串有问题：\(hex)")
            return UIColor.clear
        }
        let rStr = str.xSub(range: NSMakeRange(0, 2)) ?? "00"
        let gStr = str.xSub(range: NSMakeRange(2, 2)) ?? "00"
        let bStr = str.xSub(range: NSMakeRange(4, 2)) ?? "00"
        
        var r = UInt32(0)
        var g = r
        var b = r
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        let color = UIColor.init(red: CGFloat(r) / 255,
                                 green: CGFloat(g) / 255,
                                 blue: CGFloat(b) / 255,
                                 alpha: alpha)
        return color
    }
    /// 随机色
    /// - Parameter alpha: 透明度
    /// - Returns: 新颜色
    public static func xNewRandom(alpha : CGFloat = 1) -> UIColor
    {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        let color = UIColor.init(red: r,
                                 green: g,
                                 blue: b,
                                 alpha: alpha)
        return color
    }
    
    // TODO: 颜色修改
    /// 修改透明度
    /// - Parameter alpha: 透明度
    /// - Returns: 新颜色
    public func xEdit(alpha : CGFloat) -> UIColor
    {
        let ret = self.withAlphaComponent(alpha)
        return ret
    }
    
    /// 混合两种颜色（取平均值）
    /// - Parameters:
    ///   - color: 要混合的颜色
    ///   - ratio: 要混合的颜色占比
    ///   - alpha: 混合结果的透明度
    /// - Returns: 新颜色
    public func xMix(color: UIColor,
                     ratio: CGFloat,
                     alpha: CGFloat = 1.0) -> UIColor
    {
        // 计算两种混合颜色的占比
        guard ratio > 0 else { return self }
        guard ratio < 1 else { return color }
        let ratio1 = 1 - ratio
        let ratio2 = ratio
        // 获取颜色的颜色空间
        guard let comp1 = self.cgColor.components,
              let comp2 = color.cgColor.components else {
            return self
        }
        // 根据颜色空间设置rgb值
        var r1 = CGFloat(0), g1 = CGFloat(0), b1 = CGFloat(0)
        var r2 = CGFloat(0), g2 = CGFloat(0), b2 = CGFloat(0)
        if comp1.count > 3 {
            // 3色通道(彩色)
            r1 = comp1[0]
            g1 = comp1[1]
            b1 = comp1[2]
        } else {
            // 单色通道(黑白灰)
            r1 = comp1[0]
            g1 = comp1[0]
            b1 = comp1[0]
        }
        if comp2.count > 3 {
            // 3色通道(彩色)
            r2 = comp2[0]
            g2 = comp2[1]
            b2 = comp2[2]
        } else {
            // 单色通道(黑白灰)
            r2 = comp2[0]
            g2 = comp2[0]
            b2 = comp2[0]
        }
        // 混合操作
        let r = r1 * ratio1 + r2 * ratio2
        let g = g1 * ratio1 + g2 * ratio2
        let b = b1 * ratio1 + b2 * ratio2
        let ret = UIColor.init(red: r, green: g, blue: b, alpha: alpha)
        return ret
    }
    
    // TODO: 数据转换
    /// 转换成UIImage类型数据
    /// - Parameter size: 指定大小
    /// - Returns: 新图片
    public func xToImage(size : CGSize = .init(width: 1, height: 1)) -> UIImage?
    {
        let frame = CGRect.init(origin: .zero,
                                size: size)
        let view = UIView.init(frame: frame)
        view.backgroundColor = self
        // 绘画板
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        view.layer.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
}
