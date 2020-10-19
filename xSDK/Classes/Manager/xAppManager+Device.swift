//
//  xAppManager+Device.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit
import AdSupport

extension xAppManager {

    // MARK: - Public Func
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
    
}
