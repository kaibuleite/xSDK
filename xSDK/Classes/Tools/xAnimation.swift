//
//  xAnimation.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xAnimation: CATransition {
    
    // MARK: - Open Func
    // TODO: 快速创建
    /// 淡入淡出
    public static func fade(duration : TimeInterval,
                            timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.new(type: .fade,
                        duration: duration,
                        timing: timing)
    }
    /// 推挤
    public static func push(duration : TimeInterval,
                            timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.new(type: .push,
                        duration: duration,
                        timing: timing)
    }
    /// 覆盖
    public static func moveIn(duration : TimeInterval,
                              timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.new(type: .moveIn,
                        duration: duration,
                        timing: timing)
    }
    /// 揭开
    public static func reveal(duration : TimeInterval,
                              timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.new(type: .reveal,
                        duration: duration,
                        timing: timing)
    }
    /// 波纹
    public static func rippleEffect(duration : TimeInterval,
                                    timing : CAMediaTimingFunctionName = .linear) -> xAnimation
    {
        let type = CATransitionType(rawValue: "rippleEffect")
        return self.new(type: type,
                        duration: duration,
                        timing: timing)
    }
    
    // TODO: 自定义创建
    /// 创建动画
    /// - Parameters:
    ///   - type: 动画类型
    ///   - duration: 动画时长
    ///   - timing: 动画播放模式
    /// - Returns: 动画
    public static func new(type : CATransitionType,
                           duration : TimeInterval,
                           timing : CAMediaTimingFunctionName) -> xAnimation
    {
        let anim = xAnimation.init()
        anim.type = type
        anim.duration = duration
        anim.timingFunction = CAMediaTimingFunction.init(name: timing)
        return anim
    }
}

