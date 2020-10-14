//
//  xAnimation.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xAnimation: CATransition {
    
    // MARK: - Enum
    public enum xAnimationTypeEnum : String {
        /* 以下API效果可以安全使用 */
        /// 淡入淡出
        case fade
        /// 覆盖
        case moveIn
        /// 推挤
        case push
        /// 揭开
        case reveal
        /// 方块
        case cube
        /// 三角
        case suckEffect
        /// 水波抖动
        case rippleEffect
        /// 上翻页
        case pageCurl
        /// 下翻页
        case pageUnCurl
        /// 上下翻转
        case oglFlip
        /// 镜头快门开
        case cameraIrisHollowOpen
        /// 镜头快门开
        case cameraIrisHollowClose
        
        /* 以下API效果请慎用 */
        /// 新版面在屏幕下方中间位置被释放出来覆盖旧版面.
        case spewEffect
        /// 旧版面在屏幕左下方或右下方被吸走, 显示出下面的新版面
        case genieEffect
        /// 新版面在屏幕左下方或右下方被释放出来覆盖旧版面.
        case unGenieEffect
        /// 版面以水平方向像龙卷风式转出来.
        case twist
        /// 版面垂直附有弹性的转出来.
        case tubey
        /// 旧版面360度旋转并淡出, 显示出新版面.
        case swirl
        /// 旧版面淡出并显示新版面.
        case charminUltra
        /// 新版面由小放大走到前面, 旧版面放大由前面消失.
        case zoomyIn
        /// 新版面屏幕外面缩放出现, 旧版面缩小消失.
        case zoomyOut
        /// 像按”home” 按钮的效果.
        case oglApplicationSuspend
        
        /// 安全动画类型列表
        public static func safeTypeList() -> [xAnimationTypeEnum]
        {
            var ret = [xAnimationTypeEnum]()
            ret = [.fade, .push, .moveIn, .reveal, .cube, .suckEffect, .rippleEffect, .pageCurl, .oglFlip, .cameraIrisHollowOpen, .cameraIrisHollowClose]
            return ret
        }
        /// 不安全动画类型列表
        public static func unsafeTypeList() -> [xAnimationTypeEnum]
        {
            var ret = [xAnimationTypeEnum]()
            ret = [.spewEffect, .genieEffect, .unGenieEffect, .twist, .tubey, .swirl, .charminUltra, .zoomyIn, .zoomyOut, .oglApplicationSuspend]
            return ret
        }
    }
 
    // MARK: - Public Func
    /// 创建动画
    /// - Parameters:
    ///   - type: 动画切换风格
    ///   - subtype: 动画切换方向
    ///   - duration: 动画时长
    ///   - timing: 切换速度效果
    /// - Returns: 动画
    public static func new(type : xAnimationTypeEnum,
                           subtype : CATransitionSubtype,
                           duration : TimeInterval,
                           timing : CAMediaTimingFunctionName = .easeInEaseOut) -> xAnimation
    {
        let anim = xAnimation.init()
        anim.type = CATransitionType.init(rawValue: type.rawValue)
        anim.subtype = subtype
        anim.duration = duration
        anim.timingFunction = CAMediaTimingFunction.init(name: timing)
        return anim
    }
}

