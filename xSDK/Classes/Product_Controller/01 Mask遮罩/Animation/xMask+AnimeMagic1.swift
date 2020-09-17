//
//  xMask+AnimeMagic1.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension xMaskViewController {
    
    // MARK: - Public Func
    /// 添加魔法阵动画
    public func addMagicAnime()
    {
        // 基础参数
        let frame = self.animeContainer.layer.bounds
        let center = CGPoint.init(x: frame.width / 2.0, y: frame.height / 2.0)  // 圆心
        let duration = Double(2)    // 播放时长
        let waitingDuration = Double(1) // 暂停时长
        let radius = CGFloat(20)    // 半径
        let lineWidth = CGFloat(1)  // 线宽
        let lineColor = UIColor.purple  // 颜色
         
        // MARK: - 内圆
        // 路径
        let circle1Path = UIBezierPath()
        circle1Path.addArc(withCenter: center, radius: radius, startAngle: 0 / 180 * CGFloat.pi, endAngle: 360 / 180 * CGFloat.pi, clockwise: true)
        // 路径动画
        let circle1Anime = self.animation(keyPath: "strokeEnd", duration: duration)
        circle1Anime.fromValue = 0
        circle1Anime.toValue = 1
        let circle1AnimeGroup = self.animationGroup(animations: [circle1Anime], waitingDuration: waitingDuration)
        // 添加路径
        self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                      path: circle1Path, anime: circle1AnimeGroup)
        
        // MARK: - 外圆
        // 路径
        let circle2Path = UIBezierPath()
        circle2Path.addArc(withCenter: center, radius: radius + 4, startAngle: -180 / 180 * CGFloat.pi, endAngle: (-180 + 360) / 180 * CGFloat.pi, clockwise: true)
        // 路径动画
        let circle2Anime = self.animation(keyPath: "strokeEnd", duration: duration)
        circle2Anime.fromValue = 0
        circle2Anime.toValue = 1
        let circle2AnimeGroup = self.animationGroup(animations: [circle2Anime], waitingDuration: waitingDuration)
        // 添加路径
        self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                      path: circle2Path, anime: circle2AnimeGroup)
        
        // MARK: - 六芒星
        let offsetX = cos(30 / 180 * CGFloat.pi) * radius
        let offsetY = radius / 2
        // 计算6个顶点
        let p1 = CGPoint.init(x: center.x, y: center.y - radius)
        let p2 = CGPoint.init(x: center.x + offsetX, y: center.y - offsetY)
        let p3 = CGPoint.init(x: center.x + offsetX, y: center.y + offsetY)
        let p4 = CGPoint.init(x: center.x, y: center.y + radius)
        let p5 = CGPoint.init(x: center.x - offsetX, y: center.y + offsetY)
        let p6 = CGPoint.init(x: center.x - offsetX, y: center.y - offsetY)
        // 类型1——带边框
        if self.config.animeStyle == .magic1 {
            // MARK: - 外部边框
            // 路径
            let hexagonPath = UIBezierPath()
            hexagonPath.move(to: p1)
            hexagonPath.addLine(to: p2)
            hexagonPath.addLine(to: p3)
            hexagonPath.addLine(to: p4)
            hexagonPath.addLine(to: p5)
            hexagonPath.addLine(to: p6)
            hexagonPath.addLine(to: p1)
            // 路径动画
            let hexagonAnime = self.animation(keyPath: "strokeEnd", duration: duration)
            hexagonAnime.fromValue = 0
            hexagonAnime.toValue = 1
            let hexagonAnimeGroup = self.animationGroup(animations: [hexagonAnime], waitingDuration: waitingDuration)
            // 添加路径
            self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                          path: hexagonPath, anime: hexagonAnimeGroup)
            
            // MARK: - 内部图案
            // 路径
            let starPath = UIBezierPath()
            starPath.move(to: p1)
            starPath.addLine(to: p5)
            starPath.addLine(to: p2)
            starPath.addLine(to: p4)
            starPath.addLine(to: p6)
            starPath.addLine(to: p3)
            starPath.addLine(to: p1)
            // 路径动画
            let starAnime = self.animation(keyPath: "strokeEnd", duration: duration)
            starAnime.fromValue = 0
            starAnime.toValue = 1
            let starAnimeGroup = self.animationGroup(animations: [starAnime], waitingDuration: waitingDuration)
            // 添加路径
            self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                          path: starPath, anime: starAnimeGroup)
        }
        // 类型2——不带边框
        else {
            // MARK: - 正三角
            // 路径
            let upTrianglePath = UIBezierPath()
            upTrianglePath.move(to: p1)
            upTrianglePath.addLine(to: p5)
            upTrianglePath.addLine(to: p3)
            upTrianglePath.addLine(to: p1)
            // 路径动画
            let upTriangAnime = self.animation(keyPath: "strokeEnd", duration: duration)
            upTriangAnime.fromValue = 0
            upTriangAnime.toValue = 1
            let upTriangAnimeGroup = self.animationGroup(animations: [upTriangAnime], waitingDuration: waitingDuration)
            // 添加路径
            self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                          path: upTrianglePath, anime: upTriangAnimeGroup)
            
            // MARK: - 倒三角
            // 路径
            let downTrianglePath = UIBezierPath()
            downTrianglePath.move(to: p4)
            downTrianglePath.addLine(to: p2)
            downTrianglePath.addLine(to: p6)
            downTrianglePath.addLine(to: p4)
            // 路径动画
            let downTriangAnime = self.animation(keyPath: "strokeEnd", duration: duration)
            downTriangAnime.fromValue = 0
            downTriangAnime.toValue = 1
            let downTriangAnimeGroup = self.animationGroup(animations: [downTriangAnime], waitingDuration: waitingDuration)
            // 添加路径
            self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor,
                          path: downTrianglePath, anime: downTriangAnimeGroup)
        }
    }
}
