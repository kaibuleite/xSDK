//
//  xAppManager.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit
import AVKit

public class xAppManager: NSObject {

    // MARK: - Public Property
    /// 单例
    public static let shared = xAppManager()
    private override init() { }
    /// 是否是测试环境
    public var isDebug = true
    /// 是否打印控制台信息
    public var isLog = true
    /// 是否打印xModel参数缺少信息
    public var isLogModelNoPropertyTip = false
    
    /// 主题色
    public var themeColor = UIColor.x_hex("#487FFC")
    /// TableView背景色
    public var tableViewBackgroundColor = UIColor.groupTableViewBackground
    /// 导航栏背景色
    public var navigationBarColor = UIColor.x_hex("F7F6F6")
    /// 导航栏背阴影线条景色
    public var navigationBarShadowColor = UIColor.lightGray
    
    // MARK: - Private Property
    /// 音效id
    private let soundIDArray = [SystemSoundID]()
    
    // MARK: - Public Func
    /// 播放音效
    public static func playSound(name : String,
                                 type : String = ".mp3",
                                 id : SystemSoundID)
    {
        // 先遍历看有没有录入
        for sid in shared.soundIDArray {
            if sid == id {
                AudioServicesPlaySystemSound(id)
                return
            }
        }
        // 没有则添加
        var sid = id
        let bundle = Bundle.init(for: self.classForCoder())
        guard let path = bundle.path(forResource: name, ofType: type) else {
            x_warning("音效文件路径初始化失败:\(name).\(type)")
            return
        }
        let url = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(url as CFURL, &sid)
        AudioServicesPlaySystemSound(sid)
    }
    /// 打开手电筒
    public static func openPhoneLight()
    {
        guard let device = AVCaptureDevice.default(for: .video) else {
            x_warning("设备初始化失败")
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = .on
            device.unlockForConfiguration()
        } catch {
            
        }
    }
    /// 关闭手电筒
    public static func closePhoneLight()
    {
         guard let device = AVCaptureDevice.default(for: .video) else {
             x_warning("设备初始化失败")
             return
         }
         do {
             try device.lockForConfiguration()
             device.torchMode = .off
             device.unlockForConfiguration()
         } catch {
             
         }
    }
}
