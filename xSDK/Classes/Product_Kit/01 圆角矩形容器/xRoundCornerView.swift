//
//  xRoundCornerView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xRoundCornerView: xView {

      // 四个角的位置
      /*
                  line1
          arc0 —————————— arc1
          |                  |
    line0 |                  | line2
          |                  |
          arc3 —————————— arc2
                  line3
       */
    
    // MARK: - IBInspectable Property
    /// 所有角(优先级高)
    @IBInspectable public var radius : CGFloat = 0
    /// 左上圆角
    @IBInspectable public var tlRadius : CGFloat = 0
    /// 右上圆角
    @IBInspectable public var trRadius : CGFloat = 0
    /// 左下圆角
    @IBInspectable public var blRadius : CGFloat = 0
    /// 右下圆角
    @IBInspectable public var brRadius : CGFloat = 0

    // MARK: - Private Property
    /// 不规则圆角图层
    private let roundLayer = CAShapeLayer()
    
    // MARK: - Public Override Func
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.roundLayer.frame = self.bounds
    }
    public override func initKit()
    {
        self.backgroundColor = .white
        self.roundLayer.backgroundColor = UIColor.clear.cgColor
        self.roundLayer.fillColor = UIColor.red.cgColor
        self.roundLayer.lineWidth = 1
        self.roundLayer.lineCap = .round
        self.roundLayer.lineJoin = .round
    }
    public override func addKit()
    {
        if self.radius >= 0 {
            self.clip(cornerRadius: self.radius)
        }
        else {
            self.clip(tlRadius: self.tlRadius,
                      trRadius: self.trRadius,
                      blRadius: self.blRadius,
                      brRadius: self.brRadius)
        }
    }
    
    // MARK: - Public Func
    /// 规则圆角
    public func clip(cornerRadius : CGFloat)
    {
        self.layer.cornerRadius = cornerRadius
        self.layer.mask = nil
    }
    /// 不规则圆角
    public func clip(tlRadius : CGFloat,
                     trRadius : CGFloat,
                     blRadius : CGFloat,
                     brRadius : CGFloat)
    {
        self.layer.cornerRadius = 0
        self.layer.mask = nil
        guard tlRadius >= 0, trRadius >= 0, blRadius >= 0, brRadius >= 0 else { return }
        // 声明计算参数
        self.layoutIfNeeded()
        let frame = self.bounds
        let w = frame.width
        let h = frame.height
        var radius = CGFloat.zero
        var center = CGPoint.zero
        var toPos = CGPoint.zero
        // 开始绘制
        let path = UIBezierPath.init()
        // 左上
        radius = tlRadius
        center = CGPoint.init(x: radius, y: radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 180 / 180,
                    endAngle:   CGFloat.pi * 270 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: w - trRadius, y: 0)
        path.addLine(to: toPos)
        // 右上
        radius = trRadius
        center = CGPoint.init(x: w - radius, y: radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 270 / 180,
                    endAngle:   CGFloat.pi * 360 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: w, y: h - blRadius)
        path.addLine(to: toPos)
        // 左下
        radius = blRadius
        center = CGPoint.init(x: w - radius, y: h - radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 0 / 180,
                    endAngle:   CGFloat.pi * 90 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: brRadius, y: h)
        path.addLine(to: toPos)
        // 右下
        radius = brRadius
        center = CGPoint.init(x: radius, y: h - radius)
        path.addArc(withCenter: center, radius: radius,
                    startAngle: CGFloat.pi * 90 / 180,
                    endAngle:   CGFloat.pi * 180 / 180,
                    clockwise: true)
        toPos = CGPoint.init(x: 0, y: tlRadius)
        path.addLine(to: toPos)
        // 添加遮罩(限制显示区域)
        self.roundLayer.frame = frame
        self.roundLayer.path = path.cgPath
        self.layer.mask = self.roundLayer
    }
    
}
