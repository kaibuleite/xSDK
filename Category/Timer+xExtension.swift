//
//  Timer+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit


extension Timer {

    /// 定时器触发回调
    public typealias x_HandlerTimerInvoke = (Timer) -> Void
    
    // MARK: - 实例化对象
    /// 创建定时器
    /// - Parameters:
    ///   - timeInterval: 间隔
    ///   - repeats: 是否重复
    ///   - block: 回调
    public static func new(timeInterval : TimeInterval,
                           repeats : Bool,
                           handler : @escaping x_HandlerTimerInvoke) -> Timer
    {
        let timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(timerInvoke(_:)),
                                         userInfo: handler,
                                         repeats: repeats)
        return timer
    }
    
    // MARK: - 私有方法
    @objc private static func timerInvoke(_ timer : Timer)
    {
        let block = timer.userInfo as? x_HandlerTimerInvoke
        block?(timer)
    }
}
