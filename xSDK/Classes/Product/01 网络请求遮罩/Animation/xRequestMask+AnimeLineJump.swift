//
//  xRequestMask+AnimeLineJump.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension xRequestMaskViewController {
    
    // MARK: - Public Func
    /// 添加线条跳动动画
    public func addLineJumpAnime()
    {
        // 基础参数
        let frame = self.animeContainer.layer.bounds
        let center = CGPoint.init(x: frame.width / 2.0, y: frame.height / 2.0)  // 中心
        let duration = Double(0.2)      // 播放时长
        let count = 5                   // 线条数
        let lineWidth = CGFloat(5)      // 线宽
        let lineHeight1 = CGFloat(8)    // 线高1
        let lineHeight2 = CGFloat(15)   // 线高2
        let lineColor = UIColor.white   // 颜色
        let offset = lineWidth * 2      // 线条中心间隔
        var startX = center.x - CGFloat(count / 2) * offset // 起点X坐标
        
        for i in 0 ..< count {
            // 路径1
            let p1 = CGPoint.init(x: startX, y: center.y - lineHeight1)
            let p2 = CGPoint.init(x: startX, y: center.y + lineHeight1)
            let path1 = UIBezierPath()
            path1.move(to: p1)
            path1.addLine(to: p2)
            // 路径2
            let p3 = CGPoint.init(x: startX, y: center.y - lineHeight2)
            let p4 = CGPoint.init(x: startX, y: center.y + lineHeight2)
            let path2 = UIBezierPath()
            path2.move(to: p3)
            path2.addLine(to: p4)
            // 路径动画
            let waiting1 = CABasicAnimation()
            waiting1.duration = Double(i) * duration
            
            let anime = CABasicAnimation.init(keyPath: "path")
            anime.beginTime = waiting1.duration
            anime.duration = duration
            anime.autoreverses = true
            anime.fromValue = path1.cgPath
            anime.toValue = path2.cgPath
            
            let group = CAAnimationGroup()
            group.repeatCount = MAXFLOAT
            group.duration = Double(count) * duration
            group.animations = [waiting1, anime]
            
            // 添加路径
            self.addLayer(frame: frame, lineWidth: lineWidth, lineColor: lineColor, path: path1, anime: group)
            startX += offset
        }
        
    }
}
