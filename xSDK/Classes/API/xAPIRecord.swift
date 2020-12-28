//
//  xAPIRecord.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import Alamofire

public class xAPIRecord: NSObject {

    // MARK: - Public Property
    /// 记录id
    public var id = 0
    /// 请求方式
    public var method = HTTPMethod.post
    /// 接口地址
    public var url = ""
    /// 头部
    public var header : [String : String]?
    /// 请求参数
    public var parameter : [String : Any]?
    /// 成功回调
    public var success : xAPI.xHandlerApiRequestSuccess?
    /// 失败回调
    public var failure : xAPI.xHandlerApiRequestFailure?
    /// 是否显示成功msg
    public var isAlertSuccessMsg = false
    /// 是否显示成功msg
    public var isAlertFailureMsg = true
    /// 其他配置
    public var config = xAPIConfig()
    
    public init(config : xAPIConfig) {
        self.config = config
    }
    
}
