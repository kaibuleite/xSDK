//
//  xReqConfig.swift
//  xSDK
//
//  Created by Mac on 2021/1/11.
//

import UIKit

public class xReqConfig: NSObject {
    
    // MARK: - Enum
    /// 签名位置
    public enum SignDataPlace {
        /// 无
        case none
        /// 头部
        case header
        /// 参数
        case body
    }
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xReqConfig()
    /// 是否锁定配置数据
    public var isLockConfigData = false
    
    /// 数据摘要（签名）位置，默认放头部
    public var signPlace = SignDataPlace.header
    /// 数据摘要（签名）Key
    public var signKey = "sign"
    
}
