//
//  xReqRecord.swift
//  xSDK
//
//  Created by Mac on 2021/1/11.
//

import UIKit
import Alamofire

public class xReqRecord: NSObject {

    
    // MARK: - Public Property
    /// 记录id
    public var id = 0
    
    /// 接口地址
    public var url = ""
    /// 请求方式
    public var method = HTTPMethod.post
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
    
    /// 请求配置
    public var reqConfig = xReqConfig()
    /// 响应配置
    public var repConfig = xRepConfig()
}
