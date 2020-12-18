//
//  Test.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test: NSObject {

    /// 运行测试代码
    public static func run()
    {
        xLog("********** 设备信息 **********")
        xLog(xDeviceManager.isRoot ? "已越狱" : "未越狱")
        xLog(xDeviceManager.machineModelName)
        DispatchQueue.main.async {
            xLog("状态栏高度 \(xStatusHeight)")
        }
        // 钥匙串
        //self.keychain()
        // 哈希值
        //self.testHash()
        // 多任务处理
        //self.testGroupQueue()
        // 锁
        //self.testLock()
    }
    // MARK: - 钥匙串
    static func keychain()
    {
        xLog("********** 钥匙串 **********")
        let mgr = xKeychainManager.shared
        let data = "啊哈~！".data(using: .utf8)!
        let key = "xxx"
        xLog("保存数据")
        mgr.save(value: data, forKey: key)
        xLog("查询数据")
        if let ret = mgr.query(valueForKey: key) {
            xLog(String.init(data: ret, encoding: .utf8)!)
        }
        xLog("更新、替换数据")
        let data1 = "📚😴~！".data(using: .utf8)!
        mgr.save(value: data1, forKey: key)
        xLog("查询数据")
        if let ret = mgr.query(valueForKey: key) {
            xLog(String.init(data: ret, encoding: .utf8)!)
        }
        xLog("删除数据")
        mgr.delete(valueForKey: key)
        xLog("查询数据")
        if let ret = mgr.query(valueForKey: key) {
            xLog(String.init(data: ret, encoding: .utf8)!)
        }
    }
    
    // MARK: - 哈希值
    static func testHash()
    {
        xLog("********** 哈希值 **********")
        let a = "Hello Apple"
        xLog("MD51 = " + a.xToMD5String())
        xLog("MD52 = " + a.xToMD5String(salt: "bc"))
        xLog("SHA256 = " + a.xToSHAString(type: .SHA256))
        xLog("HMAC+SHA512 = " + a.xToHMACString(type: .SHA512, key: "abc"))
        
        let base64En = a.xToBase64EncodingString() ?? ""
        xLog("Base64 EN = " + base64En)
        let base64De = base64En.xToBase64DecodingString() ?? ""
        xLog("Base64 DE = " + base64De)
    }
    
    // MARK: - 多任务处理 https://www.jianshu.com/p/7e876ee2dcaa
    private static func testGroupQueue()
    {
        // 信号量
        xLog("********** 信号量 **********")
        let semp = DispatchSemaphore.init(value: 0)
        xLog("开始异步事件")
        DispatchQueue.global().async {
            sleep(2)
            xLog("异步结束，更新信号量")
            semp.signal()
        }
        xLog("等待信号量")
        semp.wait()
        xLog("信号量结束")
        sleep(1)
        // GCD栅栏
        xLog("********** GCD栅栏 **********")
        let queue = DispatchQueue.init(label: "Test_Que")
        xLog("开始打印水果")
        queue.async {
            for _ in 0 ... 2 { xLog("🍌") }
        }
        queue.async {
            for _ in 0 ... 2 { xLog("🍓") }
        }
        queue.async(group: nil, qos: .default, flags: .barrier) {
            xLog("水果打印完成")
        }
        sleep(1)
        // CGD组合
        xLog("********** CGD自动组合 **********")
        let group = DispatchGroup.init()
        xLog("开始打印蔬菜")
        queue.async(group: group, qos: .default) {
            for _ in 0 ... 3 { xLog("🥒") }
        }
        queue.async(group: group, qos: .default) {
            for _ in 0 ... 2 { xLog("🍆") }
        }
        let result = group.wait(timeout: .now() + 3)
        switch result {
            case .success:  xLog("蔬菜打印完成")
            case .timedOut: xLog("超时了")
        }
        sleep(2)
        xLog("********** CGD手动组合 **********")
        xLog("开始打印食物")
        group.enter()  // 手动绑定
        queue.async {
            for _ in 0 ... 2 { xLog("🍔") }
            group.leave()  // 手动释放
        }
        group.enter()  // 手动绑定
        queue.async {
            for _ in 0 ... 3 { xLog("🌭") }
            group.leave()  // 手动释放
        }
        group.notify(queue: queue) {
            xLog("食物打印完成")
        }
    }
    
    // MARK: - 锁 https://www.jianshu.com/p/8b8a01dd6356
    static func testLock()
    {
        xLog("********** 锁 **********")
        xOSSpinLock {
            xLog("OSSPinLock")
        }
        xSemaphoreLock {
            xLog("xSemaphoreLock")
        }
        if #available(iOS 10.0, *) {
            xOsUnfairLock {
                xLog("xOsUnfairLock")
            }
        }
        xPthreadMutexLock {
            xLog("xPthreadMutexLock")
        }
        xNSLock {
            xLog("xNSLock")
        }
        xSyncLock(obj: self) {
            xLog("xSyncLock")
        }
    }
}
