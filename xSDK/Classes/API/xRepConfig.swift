//
//  xRepConfig.swift
//  xSDK
//
//  Created by Mac on 2021/1/11.
//

import UIKit

public class xRepConfig: NSObject {
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xRepConfig()
    /// 是否锁定配置数据
    public var isLockConfigData = false
    
    /// 成功Code
    public var successCode = 1
    /// API请求失败——API逻辑错误
    public var failureCode = 0
    /// 网络请求失败——用户token失效，需要重新登录
    public var failureCode_UserTokenInvalid = 4000
    
    /// 返回编号Key
    public var codeKey = "code"
    /// 返回数据Key
    public var dataKey = "data"
    /// 返回信息Key
    public var msgKey = "msg"
    /// 需要重新登录Msg
    public var reLoginMsgArray = ["请先登录", "未登录", "请登录后操作"]
}
