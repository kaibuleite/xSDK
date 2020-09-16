//
//  xRequestMask+AnimeLayer.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension xRequestMaskViewController {
    
    // MARK: - Public Func
    /// 生成动画
    /// - Parameters:
    ///   - keyPath: 动画类型
    ///   - duration: 时长
    ///   - repeatCount: 重复次数（默认无限）
    ///   - autoreverses: 是否逆播放（默认否）
    public func animation(keyPath : String,
                          duration : CFTimeInterval,
                          repeatCount : Float = MAXFLOAT,
                          autoreverses : Bool = false) -> CABasicAnimation
    {
        let anime = CABasicAnimation.init(keyPath: keyPath)
        anime.duration = duration
        anime.repeatCount = repeatCount
        anime.autoreverses = autoreverses
        return anime
    }
    
    /// 生成动画组合
    /// - Parameters:
    ///   - animations: 动画数组
    ///   - waitingDuration: 播放完成等待时间（默认0）
    ///   - repeatCount: 重复次数（默认无限）
    ///   - autoreverses: 是否逆播放（默认否）
    public func animationGroup(animations : [CAAnimation],
                               waitingDuration : CFTimeInterval,
                               repeatCount : Float = MAXFLOAT,
                               autoreverses : Bool = false) -> CAAnimationGroup
    {
        // 计算动画时长
        var totalAnimations = animations
        var totalDuration = CFTimeInterval(0)
        for anime in totalAnimations {
            totalDuration += anime.duration
            // 组合动画内重置播放次数
            anime.repeatCount = 1
        }
        // 等待动画
        let waiting = CABasicAnimation.init(keyPath: "opacity")
        waiting.beginTime = totalDuration   // 等待之前的动画播放完成
        waiting.duration = waitingDuration
        waiting.repeatCount = 1
        waiting.autoreverses = autoreverses
        waiting.fromValue = 1
        waiting.toValue = 0
        // 添加等待动画
        totalDuration += waitingDuration
        totalAnimations.append(waiting)
        // 组合动画
        let group = CAAnimationGroup()
        group.animations = totalAnimations
        group.duration = totalDuration
        group.repeatCount = repeatCount
        group.autoreverses = autoreverses
        return group
    }
    
    /// 添加图层
    /// - Parameters:
    ///   - frame: 大小、坐标
    ///   - lineWidth: 线宽
    ///   - lineColor: 线条颜色
    ///   - fillColor: 填充颜色
    ///   - path: 路径
    ///   - anime: 动画
    public func addLayer(frame : CGRect,
                         lineWidth : CGFloat = 0,
                         lineColor : UIColor = .clear,
                         fillColor : UIColor = .clear,
                         path : UIBezierPath? = nil,
                         anime : CAAnimation)
    {
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.strokeColor = lineColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.path = path?.cgPath
        layer.add(anime, forKey: nil)
        self.animeLayer.addSublayer(layer)
    }
}
