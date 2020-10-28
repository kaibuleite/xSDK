//
//  xGPasswordResultView.swift
//  xSDK
//
//  Created by Mac on 2020/10/6.
//

import UIKit

class xGPasswordResultView: xClearView {
    
    // MARK: - Public Property
    /// 配置
    var config = xGPasswordResultConfig() {
        didSet {
            self.pointLayer.fillColor = self.config.pointColor.cgColor
            self.pointLayer.strokeColor = self.config.pointColor.cgColor
            
            self.lineLayer.lineWidth = self.config.lineWidth
            self.lineLayer.strokeColor = self.config.lineColor.cgColor
        }
    }
    
    // MARK: - Private Property
    /// 9宫格上的点坐标
    private var pointArray = [CGPoint]()
    /// 9宫格上的点
    private let pointLayer = CAShapeLayer()
    /// 9宫格上的线
    private let lineLayer = CAShapeLayer()
 
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isUserInteractionEnabled = false
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
        // 添加Layer
        self.pointLayer.lineWidth = 1
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.lineLayer.lineCap = .round
        self.lineLayer.lineJoin = .round
        self.layer.addSublayer(self.pointLayer)
        self.layer.addSublayer(self.lineLayer)
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.pointLayer.frame = self.bounds
        self.lineLayer.frame = self.bounds
        // 计算点
        self.pointArray.removeAll()
        let w = self.bounds.width / 2
        let h = self.bounds.height / 2
        for i in 0 ..< 9 {
            let row = i / 3
            let column = i % 3
            let x = w * CGFloat(column)
            let y = h * CGFloat(row)
            let pos = CGPoint.init(x: x, y: y)
            self.pointArray.append(pos)
        }
        // 画点
        let path = UIBezierPath.init()
        self.pointArray.forEach {
            (point) in
            path.move(to: point)
            path.addArc(withCenter: point,
                        radius: self.config.pointRadius,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        }
        self.pointLayer.path = path.cgPath
    }
    
    // MARK: - Func
    /// 设置线条
    func setLine(with gp : String)
    {
        let path = UIBezierPath.init()
        for char in gp {
            let str = char.description
            let idx = str.xToInt() - 1
            guard idx < self.pointArray.count else { continue }
            let point = self.pointArray[idx]
            if path.isEmpty {
                path.move(to: point)
            }
            else {
                path.addLine(to: point)
            }
        }
        self.lineLayer.path = path.cgPath
    }
}
