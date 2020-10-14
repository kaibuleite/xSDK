//
//  xAppManager+Audio.swift
//  xSDK
//
//  Created by Mac on 2020/10/14.
//

import UIKit
import AVKit

extension xAppManager {
    
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
            xWarning("音效文件路径初始化失败:\(name).\(type)")
            return
        }
        let url = URL(fileURLWithPath: path)
        AudioServicesCreateSystemSoundID(url as CFURL, &sid)
        AudioServicesPlaySystemSound(sid)
    }
}
