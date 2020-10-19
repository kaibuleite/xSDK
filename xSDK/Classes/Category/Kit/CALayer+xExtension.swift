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
}
