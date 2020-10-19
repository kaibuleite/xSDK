//
//  xAppManager+InfoDictionary.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit

extension xAppManager {
    
    // MARK: - Public Func
    /// 名称
    public var appBundleName : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
        let ret = name as? String ?? ""
        return ret
    }
    /// ID
    public var appBundleID : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier")
        let ret = name as? String ?? ""
        return ret
    }
    /// 版本号
    public var appVersion : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let ret = name as? String ?? ""
        return ret
    }
    /// 编译信息
    public var appBuildVersion : String {
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        let ret = name as? String ?? ""
        return ret
    }
}
