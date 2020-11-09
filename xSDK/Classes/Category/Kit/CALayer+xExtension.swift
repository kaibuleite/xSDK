//
//  CALayer+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit

extension CALayer {

    // MARK: - Public Func
    /// 截图
    public func xSnapshotImage() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    /// 截图并创建PDF
    public func xSnapshotPDF() -> Data?
    {
        let data = NSMutableData.init()
        UIGraphicsBeginPDFContextToData(data, self.bounds, nil)
        UIGraphicsBeginPDFPage()
        guard let cxt = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: cxt)
        UIGraphicsEndPDFContext()
        return data as Data
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 偏移量
    ///   - radius: 圆角半径
    public func xSetShadow(color : UIColor,
                           offset : CGSize,
                           radius : CGFloat)
    {
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = 1
        self.shouldRasterize = true
        self.rasterizationScale = UIScreen.main.scale
    }
    
    /// 添加虚线边框
    /// - Parameters:
    ///   - spacing: 虚线间隔
    ///   - length: 虚线长度
    ///   - color: 虚线颜色
    ///   - radius: 圆角半径
    public func xAddDashBorder(spacing : Double,
                               length : Double,
                               color : UIColor = .lightGray,
                               radius : CGFloat)
    {
        let frame = self.bounds
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 1
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.lineDashPhase = 0
        layer.lineDashPattern = [NSNumber(value: length),
                                 NSNumber(value: spacing)]
        let path = UIBezierPath.init(roundedRect: frame,
                                     cornerRadius: 5)
        layer.path = path.cgPath
        
        self.addSublayer(layer)
    }
}
