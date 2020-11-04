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
    private let maskLayer = CAShapeLayer()
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.maskLayer.backgroundColor = UIColor.clear.cgColor
        self.maskLayer.fillColor = UIColor.red.cgColor
        self.maskLayer.lineWidth = 1
        self.maskLayer.lineCap = .round
        self.maskLayer.lineJoin = .round
    }
    public override func viewDidAppear() {
        super.viewDidAppear()
        if self.radius > 0 {
            self.clip(cornerRadius: self.radius)
        }
        else {
            self.clip(tlRadius: self.tlRadius,
                      trRadius: self.trRadius,
                      blRadius: self.blRadius,
                      brRadius: self.brRadius)
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.maskLayer.frame = self.bounds
    }
    
    // MARK: - Public Func
    /// 规则圆角
    public func clip(cornerRadius : CGFloat)
    {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
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
        // 开始绘制
        let path = UIBezierPath.xNew(rect: frame,
                                     tlRadius: tlRadius,
                                     trRadius: trRadius,
                                     blRadius: blRadius,
                                     brRadius: brRadius)
        // 添加遮罩(限制显示区域)
        self.maskLayer.frame = frame
        self.maskLayer.path = path.cgPath
        self.layer.mask = self.maskLayer
    }
    
}
