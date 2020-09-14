//
//  xAnimation.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

class xAnimation: CATransition {
    
    // MARK: - 快速创建
    /// 淡入淡出
    open class func x_fade(duration : TimeInterval,
                           timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.x_new(type: .fade,
                          duration: duration,
                          timing: timing)
    }
    /// 推挤
    open class func x_push(duration : TimeInterval,
                           timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.x_new(type: .push,
                          duration: duration,
                          timing: timing)
    }
    /// 覆盖
    open class func x_moveIn(duration : TimeInterval,
                             timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.x_new(type: .moveIn,
                          duration: duration,
                          timing: timing)
    }
    /// 揭开
    open class func x_reveal(duration : TimeInterval,
                             timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        return self.x_new(type: .reveal,
                          duration: duration,
                          timing: timing)
    }
    /// 波纹
    open class func x_rippleEffect(duration : TimeInterval,
                                   timing : CAMediaTimingFunctionName = .linear) -> xAnimation
    {
        let type = CATransitionType(rawValue: "rippleEffect")
        return self.x_new(type: type,
                          duration: duration,
                          timing: timing)
    }
    
    // MARK: - 自定义创建
    /// 创建动画
    /// - Parameters:
    ///   - type: 动画类型
    ///   - duration: 动画时长
    ///   - timing: 动画播放模式
    /// - Returns: 动画
    open class func x_new(type : CATransitionType,
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

