//
//  xAPIConfig.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xAPIConfig: NSObject {

    // MARK: - Public Property
    // TODO: 状态码
    /// 成功Code
    public var successCode = 1
    /// API请求失败——API逻辑错误
    public var failureCode = 0
    /// 网络请求失败——网络炸了
    public var failureNetworkBrokenCode = 3000
    /// 网络请求失败——用户token失效，需要重新登录
    public var failureUserTokenInvalidCode = 4000
    /// 需要重新登录Msg
    public var reLoginMsgArray = ["请先登录", "未登录", "请登录后操作"]
    
    // TODO: 请求Key
    /// 请求签名Key
    public var reqSignKey = "sign"
    
    // TODO: 返回Key
    /// 返回编号Key
    public var repCodeKey = "code"
    /// 返回信息Key
    public var repMsgKey = "msg"
    /// 返回数据Key
    public var repDataKey = "data"
    
}
