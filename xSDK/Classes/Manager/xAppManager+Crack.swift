//
//  xAppManager+Crack.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit

extension xAppManager {
    
    // MARK: - Public Func
    /// 越狱检测（简单）
    public static func isCrack() -> Bool
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
}
