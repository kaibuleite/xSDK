//
//  xGlobalLock.swift
//  xSDK
//
//  Created by Mac on 2020/10/26.
//

import UIKit

// 参考 https://www.jianshu.com/p/8b8a01dd6356

// MARK: - 自旋锁⚠️
/// 自旋锁⚠️
/// 等待锁的线程不会睡眠，而是轮训查看锁状态
/// 由于iOS的线程优先级QoS会导致高优先级抢占低优先级线程的CPU资源而导致其无法完成任务释放lock，进而导致性能损耗，所以不推荐使用
/// - Parameter handler: 回调事件
public func xOSSpinLock(handler: () -> Void)
{
    var lock = OS_SPINLOCK_INIT
    /*
    OSSpinLockLock(&lock)
    handler()
    OSSpinLockUnlock(&lock)
     */
    xLog(">>>>>>>>> 准备上锁")
    let ret = OSSpinLockTry(&lock)
    if ret {
        xLog(">>>>>>>>> 上锁")
        handler()
        OSSpinLockUnlock(&lock)
        xLog(">>>>>>>>> 解锁")
    }
    else {
        xWarning(">>>>>>>>> 上锁失败")
    }
}

// MARK: - 自旋锁
/// 自旋锁，iOS10
/// 等待锁的线程会处于休眠状态
/// 优化OSSPinlock的线程优先级导致的bug
/// - Parameter handler: 回调事件
@available(iOS 10.0, *)
public func xOsUnfairLock(handler: () -> Void)
{
    let lock = os_unfair_lock_t.allocate(capacity: 1)
    lock.initialize(to: os_unfair_lock())
    xLog(">>>>>>>>> 准备上锁")
    let ret = os_unfair_lock_trylock(lock)
    if ret {
        xLog(">>>>>>>>> 上锁")
        handler()
        os_unfair_lock_unlock(lock)
        xLog(">>>>>>>>> 解锁")
    }
    else {
        xWarning(">>>>>>>>> 上锁失败")
    }
    // 释放资源
    lock.deinitialize(count: 1)
    lock.deallocate()
}

// MARK: - 信号量
/// 信号量
/// - Parameter handler: 回调事件
public func xSemaphoreLock(handler: () -> Void)
{
    let sp = DispatchSemaphore.init(value: 1)
    xLog(">>>>>>>>> 准备上锁")
    sp.wait()
    xLog(">>>>>>>>> 上锁")
    handler()
    sp.signal()
    xLog(">>>>>>>>> 解锁")
}

// MARK: - 普通锁（互斥锁）
/// 普通锁（互斥锁）
/// 等待锁的线程会处于休眠状态
/// - Parameter handler: 回调事件
public func xPthreadMutexLock(handler: () -> Void)
{
    var lock = pthread_mutex_t()
    pthread_mutex_init(&lock, nil)
    xLog(">>>>>>>>> 准备上锁")
    let ret = pthread_mutex_trylock(&lock)
    if ret == 0 {
        xLog(">>>>>>>>> 上锁")
        handler()
        pthread_mutex_unlock(&lock)
        xLog(">>>>>>>>> 解锁")
    }
    else {
        xWarning(">>>>>>>>> 上锁失败:\(ret)")
    }
    // 注销互斥锁// 释放它所占用的资源
    pthread_mutex_destroy(&lock)
}

// MARK: - NSLock
/// NSLock
/// 非递归锁，可以用synchronized替代
/// - Parameter handler: 回调事件
public func xNSLock(handler: () -> Void)
{
    let lock = NSLock.init()
    xLog(">>>>>>>>> 准备上锁")
    let ret = lock.try()
    if ret {
        xLog(">>>>>>>>> 上锁")
        handler()
        lock.unlock()
        xLog(">>>>>>>>> 解锁")
    }
    else {
        xWarning(">>>>>>>>> 上锁失败")
    }
}

// MARK: - 对象同步锁
/// 对象同步锁，用于修改对象内的敏感数据
/// - Parameters:
///   - obj: 对象
///   - handler: 回调事件
public func xSyncLock(obj: AnyObject,
                      handler: () -> Void)
{
    xLog(">>>>>>>>> 准备上锁")
    objc_sync_enter(obj)
    xLog(">>>>>>>>> 上锁")
    handler()
    objc_sync_exit(obj)
    xLog(">>>>>>>>> 解锁")
}
