//
//  xMask+AnimeEatBeans.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension xMaskViewController {
    
    // MARK: - Public Func
    /// 添加吃豆人动画
    public func addEatBeansAnime()
    {
        // 基础参数
        let frame = self.animeContainer.layer.bounds
        var center = CGPoint.init(x: frame.width / 2.0, y: frame.height / 2.0)  // 圆心
        let duration = Double(0.25)     // 播放时长
        let mouthAngle = 40 / 180 * CGFloat.pi  // 嘴巴角度
        let mouthRadius = CGFloat(20)   // 嘴巴半径
        let eyeRadius = CGFloat(3)      // 眼睛半径
        let beanRadius = CGFloat(5)     // 豆子半径
        let mouthColor = UIColor.yellow // 嘴巴颜色
        let eyeColor = UIColor.blue     // 眼睛颜色
        let beanColor = UIColor.yellow  // 豆子颜色
        
        // MARK: - 豆子
        // 修改参数
        center.x = frame.width + beanRadius
        center.y = frame.height / 2.0
        // 路径1
        let beanPath1 = UIBezierPath()
        beanPath1.move(to: center)
        beanPath1.addArc(withCenter: center, radius: beanRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        // 修改参数
        center.x = frame.width / 2.0 - beanRadius
        // 路径2
        let beanPath2 = UIBezierPath()
        beanPath2.move(to: center)
        beanPath2.addArc(withCenter: center, radius: beanRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        // 路径动画
        let beanAnime = self.animation(keyPath: "path", duration: duration * 4, autoreverses: false)
        beanAnime.fromValue = beanPath1.cgPath
        beanAnime.toValue = beanPath2.cgPath
        // 添加路径
        self.addLayer(frame: frame, fillColor: beanColor, anime: beanAnime)
        
        // MARK: - 嘴巴
        // 路径1
        let mouthPath1 = UIBezierPath()
        mouthPath1.move(to: center)
        mouthPath1.addArc(withCenter: center, radius: mouthRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        // 路径2
        let mouthPath2 = UIBezierPath()
        mouthPath2.move(to: center)
        mouthPath2.addArc(withCenter: center, radius: mouthRadius, startAngle: mouthAngle, endAngle: CGFloat.pi * 2 - mouthAngle, clockwise: true)
        // 路径动画
        let mouthAnime = self.animation(keyPath: "path", duration: duration, autoreverses: true)
        mouthAnime.fromValue = mouthPath1.cgPath
        mouthAnime.toValue = mouthPath2.cgPath
        // 添加路径
        self.addLayer(frame: frame, fillColor: mouthColor, anime: mouthAnime)
        
        // MARK: - 眼睛
        // 修改参数
        center.y -= mouthRadius / 2.0
        // 路径1
        let eyePath1 = UIBezierPath()
        eyePath1.move(to: center)
        eyePath1.addArc(withCenter: center, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        // 修改参数
        center.x -= eyeRadius / 2.0
        center.y -= eyeRadius / 2.0
        // 路径2
        let eyePath2 = UIBezierPath()
        eyePath2.move(to: center)
        eyePath2.addArc(withCenter: center, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        // 路径动画
        let eyeAnime = self.animation(keyPath: "path", duration: duration, autoreverses: true)
        eyeAnime.fromValue = eyePath1.cgPath
        eyeAnime.toValue = eyePath2.cgPath
        // 添加路径
        self.addLayer(frame: frame, fillColor: eyeColor, anime: eyeAnime)
    }
}
