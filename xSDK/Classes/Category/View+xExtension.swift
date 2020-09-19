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
        // 绘画板
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.interpolationQuality = .none   // 高质量
        self.layer.render(in: ctx)
        let ret = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ret
    }
    
    // TODO: 布局
    /// 添加布局
    public func x_addLayout(attribute attr1: NSLayoutConstraint.Attribute,
                            relatedBy relation: NSLayoutConstraint.Relation,
                            toItem view2: UIView,
                            attribute attr2: NSLayoutConstraint.Attribute,
                            multiplier: CGFloat = 1,
                            constant: CGFloat = 0)
    {
        let layout = NSLayoutConstraint.init(item: self,
                                             attribute: attr1,
                                             relatedBy: relation,
                                             toItem: view2,
                                             attribute: attr2,
                                             multiplier: multiplier,
                                             constant: constant)
        self.addConstraint(layout)
    }
    /// 添加布局
    public func x_addLayout(attribute attr1: NSLayoutConstraint.Attribute,
                            relatedBy relation: NSLayoutConstraint.Relation,
                            multiplier: CGFloat = 1,
                            constant: CGFloat = 0)
    {
        let layout = NSLayoutConstraint.init(item: self,
                                             attribute: attr1,
                                             relatedBy: relation,
                                             toItem: nil,
                                             attribute: attr1,
                                             multiplier: multiplier,
                                             constant: constant)
        self.addConstraint(layout)
    }
    /// 添加顶部约束
    public func x_addTopLayout(toItem view2: UIView,
                               constant: CGFloat = 0)
    {
        self.x_addLayout(attribute: .top, relatedBy: .equal, toItem: view2,
                         attribute: .top, multiplier: 1, constant: constant)
    }
    /// 添加底部约束
    public func x_addBottomLayout(toItem view2: UIView,
                                  constant: CGFloat = 0)
    {
        self.x_addLayout(attribute: .bottom, relatedBy: .equal, toItem: view2,
                         attribute: .bottom, multiplier: 1, constant: constant)
    }
    /// 添加左部约束
    public func x_addLeadingLayout(toItem view2: UIView,
                                   constant: CGFloat = 0)
    {
        self.x_addLayout(attribute: .leading, relatedBy: .equal, toItem: view2,
                         attribute: .leading, multiplier: 1, constant: constant)
    }
    /// 添加右部约束
    public func x_addTrailingLayout(toItem view2: UIView,
                                    constant: CGFloat = 0)
    {
        self.x_addLayout(attribute: .trailing, relatedBy: .equal, toItem: view2,
                         attribute: .trailing, multiplier: 1, constant: constant)
    }
    /// 添加铺满约束
    public func x_addFullLayout(toItem view2: UIView,
                                constant: CGFloat = 0)
    {
        self.x_addTopLayout(toItem: view2)
        self.x_addBottomLayout(toItem: view2)
        self.x_addLeadingLayout(toItem: view2)
        self.x_addTrailingLayout(toItem: view2)
    }
    
}
