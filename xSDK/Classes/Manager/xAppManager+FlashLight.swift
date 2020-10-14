//
//  xAppManager+FlashLight.swift
//  xSDK
//
//  Created by Mac on 2020/10/14.
//

import UIKit
import AVKit

extension xAppManager {
    
    // MARK: - Public Func
    /// 打开手电筒
    public static func openFlashLight()
    {
        guard let device = AVCaptureDevice.default(for: .video) else {
            xWarning("设备初始化失败")
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
    public static func closeFlashLight()
    {
         guard let device = AVCaptureDevice.default(for: .video) else {
             xWarning("设备初始化失败")
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
