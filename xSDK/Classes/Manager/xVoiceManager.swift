//
//  xVoiceManager.swift
//  xSDK
//
//  Created by Mac on 2020/10/26.
//

import UIKit
import AVKit

public class xVoiceManager: NSObject {
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xVoiceManager()
    private override init() { }
    
    // MARK: - Private Property
    /// 音效id
    var soundIDArray = [SystemSoundID]()
    
    // MARK: - Public Func
    /// 播放音效
    /// - Parameters:
    ///   - name: 文件名
    ///   - bundle: 所在的包
    ///   - type: 文件类型
    ///   - id: 文件编号
    public static func playSound(name : String,
                                 bundle: Bundle,
                                 type : String = "mp3",
                                 id : SystemSoundID)
    {
        // 先遍历看有没有录入
        for sid in shared.soundIDArray {
            guard sid == id else { continue }
            AudioServicesPlaySystemSound(id)
            return
        }
        // 没有则添加
        var sid = id
        guard let path = bundle.path(forResource: name, ofType: type) else {
            xWarning("音效文件路径初始化失败:\(name).\(type)")
            return
        }
        let url = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(url as CFURL, &sid)
        AudioServicesPlaySystemSound(sid)
        shared.soundIDArray.append(sid)
    }
}
