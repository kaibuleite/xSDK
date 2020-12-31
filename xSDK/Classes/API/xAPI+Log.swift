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
    static func formatGetString(of parameters : [String : Any]?) -> String
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
    static func formatPostString(of parameters : [String : Any]?) -> String
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
    /// 响应失败
    static func logResponseError(response : DataResponse<Any>,
                                 record : xAPIRecord?)
    {
        xWarning("API 响应失败")
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
    static func logApiCodeError(data : [String : Any],
                                record : xAPIRecord?)
    {
        xWarning("API Code 错误")
        xLog("************************************")
        if let obj = record {
            xLog("接口地址：\(self.urlPrefix() + obj.url)")
            xLog("GET参数：\(self.formatGetString(of: obj.parameter))")
            xLog("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        xLog("\(data)")
        xLog("************************************")
    }
    /// 数据解析错误
    static func logCheckDataError(data : Any?,
                                  record : xAPIRecord?)
    {
        xWarning("API 数据解析失败")
        xLog("************************************")
        // NSURLErrorTimedOut
        if let obj = record {
            xLog("接口地址：\(self.urlPrefix() + obj.url)")
            xLog("GET参数：\(self.formatGetString(of: obj.parameter))")
            xLog("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        if let str = data as? String {
            self.showDebugWeb(html: str)
        }
        else
        if let obj = data as? Data {
            if let str = String.init(data: obj, encoding: .utf8) {
                self.showDebugWeb(html: str)
            }
            else {
                xLog(obj)
            }
        }
        xLog("************************************")
    }
}
