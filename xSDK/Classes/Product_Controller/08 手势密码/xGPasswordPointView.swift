//
//  xGPasswordPointView.swift
//  xSDK
//
//  Created by Mac on 2020/10/6.
//

import UIKit

class xGPasswordPointView: xClearView {
    
    // MARK: - Public Property
    /// 是否选中
    var isChoose = false {
        didSet {
            if isChoose {
                self.interLayer.fillColor = self.config.interFillChooseColor.cgColor
                self.outerLayer.fillColor = self.config.outerFillChooseColor.cgColor
                
                self.interLayer.strokeColor = self.config.interStrokeChooseColor.cgColor
                self.outerLayer.strokeColor = self.config.outerStrokeChooseColor.cgColor
            }
            else {
                self.interLayer.fillColor = self.config.interFillNormalColor.cgColor
                self.outerLayer.fillColor = self.config.outerFillNormalColor.cgColor
                
                self.interLayer.strokeColor = self.config.interStrokeNromalColor.cgColor
                self.outerLayer.strokeColor = self.config.outerStrokeNromalColor.cgColor
                
                self.transform = .identity
                self.arrowLayer.isHidden = true
            }
        }
    }
    /// 配置
    var config = xGPasswordPointConfig() {
        didSet {
            self.interLayer.fillColor = self.config.interFillNormalColor.cgColor
            self.outerLayer.fillColor = self.config.outerFillNormalColor.cgColor
            
            self.interLayer.strokeColor = self.config.interStrokeNromalColor.cgColor
            self.outerLayer.strokeColor = self.config.outerStrokeNromalColor.cgColor
            
            self.arrowLayer.fillColor = self.config.arrowColor.cgColor
        }
    }
    
    // MARK: - Private Property
    /// 内点
    private let interLayer = CAShapeLayer()
    /// 外点
    private let outerLayer = CAShapeLayer()
    /// 箭头
    private let arrowLayer = CAShapeLayer()
 
    // MARK: - Override Func
    override func initKit()
    {
        self.isUserInteractionEnabled = false
        self.arrowLayer.isHidden = true
    }
    override func addKit()
    {
        // 添加Layer
        self.interLayer.lineWidth = 1
        self.interLayer.lineCap = .round
        self.interLayer.lineJoin = .round
        self.outerLayer.lineWidth = 1
        self.outerLayer.lineCap = .round
        self.outerLayer.lineJoin = .round
        self.arrowLayer.lineWidth = 1
        self.arrowLayer.lineCap = .round
        self.arrowLayer.lineJoin = .round
        self.layer.addSublayer(self.outerLayer)
        self.layer.addSublayer(self.interLayer)
        self.layer.addSublayer(self.arrowLayer)
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.interLayer.frame = self.bounds
        self.outerLayer.frame = self.bounds
        // 画点
        let x = self.bounds.width / 2
        let y = self.bounds.height / 2
        let center = CGPoint.init(x: x, y: y)
        let pathInter = UIBezierPath.init()
        pathInter.addArc(withCenter: center,
                         radius: self.config.interRadius,
                         startAngle: 0, endAngle: CGFloat.pi * 2,
                         clockwise: true)
        self.interLayer.path = pathInter.cgPath
        
        let pathOuter = UIBezierPath.init()
        pathOuter.addArc(withCenter: center,
                         radius: self.config.outerRadius,
                         startAngle: 0, endAngle: CGFloat.pi * 2,
                         clockwise: true)
        self.outerLayer.path = pathOuter.cgPath
        // 箭头
        let pathArrow = UIBezierPath.init()
        let len = self.config.arrowLength
        let margin = self.config.arrowMargin
        let ah = CGFloat(sqrt(Double(len * len) - Double(len / 2 * len / 2)))    // 勾股定理算高度
        /*
                    p1
                    |  \
         center ————|———p2——
                    |  /
                    p3
         */
        let ax = x + self.config.outerRadius + margin
        let p1 = CGPoint.init(x: ax , y: y - len / 2)
        let p2 = CGPoint.init(x: ax + ah, y: y)
        let p3 = CGPoint.init(x: ax , y: y + len / 2)
        pathArrow.move(to: p1)
        pathArrow.addLine(to: p2)
        pathArrow.addLine(to: p3)
        pathArrow.addLine(to: p1)
        self.arrowLayer.path = pathArrow.cgPath
    }
    
    // MARK: - Func
    /// 设置箭头
    func addArrow(to view : xGPasswordPointView)
    {
        guard let win = xKeyWindow else { return }
        self.arrowLayer.isHidden = false
        let center1 = CGPoint.init(x: self.bounds.width / 2,
                                   y: self.bounds.height / 2)
        let center2 = CGPoint.init(x: view.bounds.width / 2,
                                   y: view.bounds.height / 2)
        let pos1 = win.convert(center1, from: self)
        let pos2 = win.convert(center2, from: view)
        let x = Double(pos2.x - pos1.x)
        let y = Double(pos2.y - pos1.y)
        var angle = CGFloat(atan(y / x))
        // 补角
        if x < 0 {
            angle += CGFloat.pi
        }
        else {
            if y < 0 {
                angle += 2 * CGFloat.pi
            }
        }
        // 旋转
        self.transform = .init(rotationAngle: angle)
    }
}
