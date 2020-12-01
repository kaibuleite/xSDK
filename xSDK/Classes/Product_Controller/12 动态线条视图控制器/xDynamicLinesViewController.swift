//
//  xDynamicLinesViewController.swift
//  xSDK
//
//  Created by Mac on 2020/12/1.
//

import UIKit

open class xDynamicLinesViewController: xViewController {

    // MARK: - Private Property
    /// 刷新定时器
    var refreshTimer : CADisplayLink?
    /// 填充色
    let fillColor = UIColor.init(red: 100 / 255, green: 100 / 255, blue: 100 / 255, alpha: 1)
    /// 圆点Layer
    let pointLayer = CAShapeLayer()
    /// layer容器
    let layerContainer = UIView()
    /// 点数组
    var pointArray = [xDynamicPoint]()
    /// 线条Layer数组
    var lineLayerArray = [xDynamicLineLayer]()
    
    // MARK: - 内存释放
    deinit {
        self.refreshTimer?.invalidate() 
    }
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.layerContainer.backgroundColor = .clear
        self.view.addSubview(self.layerContainer)
        // 圆点
        self.pointLayer.fillColor = self.fillColor.cgColor
        self.pointLayer.strokeColor = self.fillColor.cgColor
        self.pointLayer.backgroundColor = UIColor.clear.cgColor
        self.pointLayer.lineJoin = .round
        self.pointLayer.lineCap = .round
        self.layerContainer.layer.addSublayer(self.pointLayer)
        // 默认设置10个点
        self.setPoint(count: 13)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let frame = self.view.bounds
        self.layerContainer.frame = frame
        self.lineLayerArray.forEach {
            (layer) in
            layer.frame = frame
        }
        self.pointLayer.frame = frame
        self.run()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stop()
    }
    
    // MARK: - Public Func
    /// 设置点数
    public func setPoint(count : Int)
    {
        // 清空数据
        self.pointLayer.path = nil
        self.lineLayerArray.forEach {
            (layer) in
            layer.path = nil
        }
        self.pointArray.removeAll()
        self.lineLayerArray.removeAll()
        // 添加点数据
        for _ in 0 ..< count
        {
            let pos = xDynamicPoint.randomPoint()
            self.pointArray.append(pos)
        }
        // 添加线数据
        for i in 0 ..< count {
            for j in i+1 ..< count {
                let line = xDynamicLineLayer.defaulStyleLayer()
                line.point1 = self.pointArray[i]
                line.point2 = self.pointArray[j]
                self.lineLayerArray.append(line)
                self.layerContainer.layer.addSublayer(line)
            }
        }
    }
    
    /// 开始动画
    public func run()
    {
        self.stop()
        self.refreshTimer = CADisplayLink.init(target: self, selector: #selector(refreshUI))
        self.refreshTimer?.add(to: .main, forMode: .common)
    }
    
    /// 结束动画
    public func stop()
    {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }
    
    // MARK: - Private Func
    /// 刷新UI
    @objc func refreshUI()
    {
        guard self.pointArray.count > 0 else { return }
        // 修改点的偏移量
        let path = UIBezierPath.init()
        for pos in self.pointArray {
            pos.updateOrigin()
            let center = pos.toPoint()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: pos.r,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        }
        self.pointLayer.path = path.cgPath
        
        // 更新点之间的连线(冒泡遍历)
        for line in self.lineLayerArray {
            let pos1 = line.point1
            let pos2 = line.point2
            // 勾股定理求线长
            let sideA = abs(pos1.x - pos2.x)
            let sideB = abs(pos1.y - pos2.y)
            let len = sqrt(sideA * sideA + sideB * sideB)
            var alpha = CGFloat(0)
            // 根据线长来设置淡化
            let maxLen = xScreenWidth / 3 * 2
            if len <= maxLen {
                alpha = 1 - (len / maxLen)
            }
            // 画线
            if alpha > 0 {
                line.strokeColor = self.fillColor.xEdit(alpha: alpha).cgColor
                let path = UIBezierPath.init()
                path.move(to: pos1.toPoint())
                path.addLine(to: pos2.toPoint())
                line.path = path.cgPath
            }
            else {
                line.path = nil
            }
        }
    }
}
