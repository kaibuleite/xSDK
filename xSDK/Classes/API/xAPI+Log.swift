//
//  xAPI+Log.swift
//  xSDK
//
//  Created by Mac on 2020/12/28.
//

import UIKit
import Alamofire

extension xAPI {
    
    // MARK: - 格式化GET参数为字符串
    /// 格式化GET参数为字符串
    public static func formatGetString(of parameters : [String : Any]?) -> String
    {
        var ret = ""
        guard let param = parameters else { return ret }
        for (key, value) in param {
            if ret != "" {
                ret += "&"
            }
            ret += key + "=" + "\(value)"
        }
        return ret
    }
    
    // MARK: - 格式化POST参数为字符串
    /// 格式化POST参数为字符串
    public static func formatPostString(of parameters : [String : Any]?) -> String
    {
        var ret = ""
        guard let param = parameters else {
            return ret
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else {
            return ret
        }
        ret = String.init(data: data, encoding: .utf8) ?? "JSON转换错误"
        return ret
    }
    
    // MARK: - 错误日志打印 
    /// 返回错误
    public static func logResponseError(record : xAPIRecord?,
                                        response : DataResponse<Any>)
    {
        xWarning("网络请求错误")
        xLog("************************************")
        if let obj = record {
            xLog("接口地址：\(self.urlPrefix() + obj.url)")
            xLog("GET参数：\(self.formatGetString(of: obj.parameter))")
            xLog("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        if let data = response.data {
            xLog("\(String.init(data: data, encoding: .utf8) ?? "")")
        }
        xLog("************************************")
    }
    /// Api逻辑错误
    public static func logApiCodeError(record : xAPIRecord?,
                                       info : [String : Any])
    {
        xWarning("API Code 错误")
        xLog("************************************")
        if let obj = record {
            xLog("接口地址：\(self.urlPrefix() + obj.url)")
            xLog("GET参数：\(self.formatGetString(of: obj.parameter))")
            xLog("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        xLog("\(info)")
        xLog("************************************")
    }
    /// 数据解析错误
    public static func logDataError(record : xAPIRecord?,
                                    isReqSuccess : Bool,
                                    response : DataResponse<Any>)
    {
        xWarning("API请求\(isReqSuccess ? "成功" : "失败")，数据解析失败")
        xLog("************************************")
        // NSURLErrorTimedOut
        if let obj = record {
            xLog("接口地址：\(self.urlPrefix() + obj.url)")
            xLog("GET参数：\(self.formatGetString(of: obj.parameter))")
            xLog("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        xLog(response.error?.localizedDescription ?? "")
        xLog("************************************")
        guard let data = response.data else { return }
        guard let html = String.init(data: data, encoding: .utf8) else { return }
        self.showDebugWeb(html: html)
    }
}
