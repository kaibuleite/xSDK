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
    public static func formatterGetString(of parameters : [String : Any]?) -> String
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
    public static func formatterPostString(of parameters : [String : Any]?) -> String
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
    public static func logResponseError(response : DataResponse<Any>,
                                        record : xReqRecord?)
    {
        xWarning("API 响应失败")
        xLog("************************************")
        self.logReqRecordInfo(record)
        if let obj = response.data {
            if let str = String.init(data: obj, encoding: .utf8) {
                self.showDebugWeb(html: str)
            }
            else {
                xLog(obj)
            }
        }
        xLog("************************************")
    }
    /// Api逻辑错误
    public static func logApiCodeError(data : [String : Any],
                                       record : xReqRecord?)
    {
        xWarning("API Code 错误")
        xLog("************************************")
        self.logReqRecordInfo(record)
        xLog("\(data)")
        xLog("************************************")
    }
    /// 数据解析错误
    public static func logCheckDataError(data : Any?,
                                         record : xReqRecord?)
    {
        xWarning("API 数据解析失败")
        xLog("************************************")
        self.logReqRecordInfo(record)
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
    
    /// 输出请求记录信息
    private static func logReqRecordInfo(_ record : xReqRecord?)
    {
        guard let obj = record else { return }
        xLog("接口地址：\(self.getUrlPrefix() + obj.url)")
        xLog("GET参数：\(self.formatterGetString(of: obj.parameter))")
        xLog("POST参数：\(self.formatterPostString(of: obj.parameter))")
    }
}
