//
//  xDeviceManager.swift
//  xSDK
//
//  Created by Mac on 2020/10/26.
//

import UIKit
import AdSupport
import AVKit

public class xDeviceManager: NSObject {

    // MARK: - Public Func
    // TODO: 身份标识
    /// 系统版本
    public static func systemVersion() -> String
    {
        let ret = UIDevice.current.systemVersion
        return ret
    }
    
    /// UUID
    public static func UUID() -> String
    {
        let ret = NSUUID.init().uuidString
        return ret
    }
    
    /// IDFA
    public static func IDFA() -> String
    {
        let ret = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return ret
    }
    
    // TODO: 状态判断
    /// 是否是iPAd
    public static func isPad() -> Bool
    {
        let ret = UI_USER_INTERFACE_IDIOM() == .pad
        return ret
    }
    
    /// 是否是模拟器
    public static func isSimulator() -> Bool
    {
        let ret = UIDevice.current.model.xContains(subStr: "Simulator")
        return ret
    }
    
    /// 是否越狱
    @discardableResult
    public static func isRoot() -> Bool
    {
        if self.isSimulator() {
            xLog("模拟器环境下不用检测")
            return false
        }
        
        if getgid() <= 10 { return true } // process ID shouldn't be root
        if let dict = Bundle.main.infoDictionary as NSDictionary? {
            if let _ = dict.object(forKey: "SignerIdentity") {
                return true
            }
        }
        let pathArr = ["/Applications/Cydia.app",
                       "/private/var/lib/apt/",
                       "/private/var/lib/cydia",
                       "/private/var/stash"]
        let mgr = FileManager.default
        for path in pathArr {
            if mgr.fileExists(atPath: path) {
                xWarning("存在越狱文件夹:\(path)")
                return true
            }
        }
        
        let bash = fopen("/bin/bash", "r");
        if (bash != nil) {
            fclose(bash)
            xWarning("检测到越狱权限，进程编号太靠前")
            return true
        }
        
        do {
            let path = String.init(format: "/private/%@", self.UUID())
            try "xx".write(toFile: path, atomically: true, encoding: .utf8)
            try mgr.removeItem(atPath: path)
            xWarning("存在越狱文件夹:\(path)")
            return true
        } catch {
            xLog(error.localizedDescription)
        }
        /*
        let bundlePath = Bundle.main.bundlePath
        let path1 = "\(bundlePath)/_CodeSignature"
        if mgr.fileExists(atPath: path1) {
            xWarning("存在越狱文件夹:\(path1)")
            return true
        }
        let path2 = "\(bundlePath)/SC_Info"
        if mgr.fileExists(atPath: path2) {
            xWarning("存在越狱文件夹:\(path2)")
            return true
        }
         */
        xLog("没有越狱")
        return false
    }
    
    // TODO: 硬件相关
    /// 设置手电筒状态
    /// - Parameter isOn: 是否打开
    public static func setFlashLight(_ torchMode: AVCaptureDevice.TorchMode)
    {
        guard let device = AVCaptureDevice.default(for: .video) else {
            xWarning("设备初始化失败")
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = torchMode
            device.unlockForConfiguration()
        } catch {
            xWarning(error.localizedDescription)
        }
    }
}
