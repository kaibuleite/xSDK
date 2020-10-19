//
//  View+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIView {
    
    // MARK: - Public Func
    // TODO: 截图
    /// 截图
    public func xSnapshotImage() -> UIImage?
    {
        let ret = self.layer.xSnapshotImage()
        return ret
    }
    /// 截图并创建PDF
    public func xSnapshotPDF() -> Data?
    {
        let ret = self.layer.xSnapshotPDF()
        return ret
    }
    /// 设置阴影
    public func xSetShadow(color : UIColor,
                           offset : CGSize,
                           radius : CGFloat)
    {
        self.layer.xSetShadow(color: color, offset: offset, radius: radius)
    }
    
    // TODO: 控件
    /// 移除所有子控件
    public func xRemoveAllSubViews()
    {
        for obj in self.subviews {
            obj.removeFromSuperview()
        }
    }
    /// 所在的ViewController
    public func xContainerViewController() -> UIViewController?
    {
        return nil
    }
    
    // TODO: 锚点
    /// 重置锚点
    /// - Parameter anchorPoint: 新锚点
    public func xSetAnchor(point : CGPoint)
    {
        let origin_old = self.frame.origin
        self.layer.anchorPoint = point
        let origin_new = self.frame.origin
        
        var center = self.center
        center.x -= (origin_new.x - origin_old.x)
        center.y -= (origin_new.y - origin_old.y)
        
        self.center = center
    }
    
    // TODO: 数据转换
    /// 将当前视图转为UIImage
    public func xToImage() -> UIImage?
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
    
    // TODO: 约束布局
    /// 添加相对布局
    public func xAddLayout(attribute attr1: NSLayoutConstraint.Attribute,
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
    /// 添加顶部约束
    public func xAddTopLayout(toItem view2: UIView,
                              constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .top, relatedBy: .equal, toItem: view2,
                        attribute: .top, multiplier: 1, constant: constant)
    }
    /// 添加底部约束
    public func xAddBottomLayout(toItem view2: UIView,
                                 constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .bottom, relatedBy: .equal, toItem: view2,
                        attribute: .bottom, multiplier: 1, constant: constant)
    }
    /// 添加左部约束
    public func xAddLeadingLayout(toItem view2: UIView,
                                  constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .leading, relatedBy: .equal, toItem: view2,
                        attribute: .leading, multiplier: 1, constant: constant)
    }
    /// 添加右部约束
    public func xAddTrailingLayout(toItem view2: UIView,
                                   constant: CGFloat = 0)
    {
        self.xAddLayout(attribute: .trailing, relatedBy: .equal, toItem: view2,
                        attribute: .trailing, multiplier: 1, constant: constant)
    }
    /// 添加铺满约束
    public func xAddFullLayout(toItem view2: UIView,
                               constant: CGFloat = 0)
    {
        self.xAddTopLayout(toItem: view2)
        self.xAddBottomLayout(toItem: view2)
        self.xAddLeadingLayout(toItem: view2)
        self.xAddTrailingLayout(toItem: view2)
    }
    
    /// 添加自身布局
    public func xAddLayout(attribute attr1: NSLayoutConstraint.Attribute,
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
    /// 添加宽度约束
    public func xAddWidthLayout(multiplier: CGFloat = 1,
                                constant: CGFloat)
    {
        self.xAddLayout(attribute: .width,
                        relatedBy: .equal,
                        multiplier: multiplier,
                        constant: constant)
    }
    /// 添加高度约束
    public func xAddHeightLayout(multiplier: CGFloat = 1,
                                  constant: CGFloat)
    {
        self.xAddLayout(attribute: .height,
                        relatedBy: .equal,
                        multiplier: multiplier,
                        constant: constant)
    }
}
