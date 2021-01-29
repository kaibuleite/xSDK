//
//  xAPI+Req.swift
//  xSDK
//
//  Created by Mac on 2020/12/28.
//

import UIKit
import Alamofire

extension xAPI {
    
    // MARK: - REQ请求
    public static func req(urlStr : String,
                           method : HTTPMethod,
                           header : [String : String]? = nil,
                           parameter : [String : Any]?,
                           isAlertSuccessMsg : Bool = false,
                           isAlertFailureMsg : Bool = true,
                           queue : DispatchQueue? = .main,
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        shared.requestCount += 1
        // 创建请求记录
        let record = xReqRecord.init()
        record.id = shared.requestCount
        record.url = urlStr
        record.method = method
        record.header = header
        record.parameter = parameter
        record.isAlertSuccessMsg = isAlertSuccessMsg
        record.isAlertFailureMsg = isAlertFailureMsg
        record.success = success
        record.failure = failure
        // 添加配置信息
        record.reqConfig = self.getReqConfig()
        record.repConfig = self.getRepConfig()
        shared.requestRecordList.append(record)
        
        // 格式化请求数据
        var fm_url = self.formatterReq(url: urlStr)
        var fm_head = self.formatterReq(header: header)
        var fm_parm = self.formatterReq(parameter: parameter)
        
        // 数据摘要(签名)处理
        if let sign = self.sign(url: fm_url, header: fm_head, parameter: fm_parm) {
            switch record.reqConfig.signPlace {
            case .header:   fm_head[record.reqConfig.signKey] = sign
            case .body:     fm_parm[record.reqConfig.signKey] = sign
            default: break
            }
        }
        
        // GET请求拼接参数到URL中
        if method == .get, fm_parm.count > 0 {
            let getStr = self.formatterGetString(of: fm_parm)
            fm_url = fm_url + "?" + getStr
            // URL编码(先解码再编码，防止2次编码)
            fm_url = fm_url.xToUrlDecodeString() ?? fm_url
            fm_url = fm_url.xToUrlEncodeString() ?? fm_url
            fm_parm.removeAll() // 重置参数对象
        }
        
        // 创建请求体
        let request = Alamofire.request(fm_url,
                                        method: method,
                                        parameters: fm_parm,
                                        headers: fm_head)
        // 校验请求信息、进行请求
        request.validate().responseJSON(queue: queue) {
            (response) in
            // 处理请求结果
            self.check(response: response,
                       record: record)
        }
    }
    
    // MARK: - GET请求
    /// GET请求
    public static func get(urlStr : String,
                           header : [String : String]? = nil,
                           parameter : [String : String]?,
                           isAlertSuccessMsg : Bool = false,
                           isAlertFailureMsg : Bool = true,
                           queue : DispatchQueue? = .main,
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .get,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
                 queue: queue,
                 success: success,
                 failure: failure)
    }
    
    // MARK: - POS请求
    /// POS请求
    public static func post(urlStr : String,
                            header : [String : String]? = nil,
                            parameter : [String : Any]?,
                            isAlertSuccessMsg : Bool = false,
                            isAlertFailureMsg : Bool = true,
                            queue : DispatchQueue? = .main,
                            success : @escaping xHandlerApiRequestSuccess,
                            failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .post,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
                 queue: queue,
                 success: success,
                 failure: failure)
    }
    
    // MARK: - PUT请求
    /// PUT请求
    public static func put(urlStr : String,
                           header : [String : String]? = nil,
                           parameter : [String : Any]?,
                           isAlertSuccessMsg : Bool = false,
                           isAlertFailureMsg : Bool = true,
                           queue : DispatchQueue? = .main,
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .put,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
                 queue: queue,
                 success: success,
                 failure: failure)
    }
    
    // MARK: - Delete请求
    /// Delete请求
    public static func delete(urlStr : String,
                              header : [String : String]? = nil,
                              parameter : [String : Any]?,
                              isAlertSuccessMsg : Bool = false,
                              isAlertFailureMsg : Bool = true,
                              queue : DispatchQueue? = .main,
                              success : @escaping xHandlerApiRequestSuccess,
                              failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .delete,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
                 queue: queue,
                 success: success,
                 failure: failure)
    }
    
    // MARK: - 上传文件
    /// 上传文件
    public static func upload(urlStr : String,
                              method : HTTPMethod,
                              header : [String : String]? = nil,
                              parameter : [String : String]?,
                              file : Data,
                              name : String,
                              type : xAPI.xUploadFileType,
                              isAlertSuccessMsg : Bool = false,
                              isAlertFailureMsg : Bool = true,
                              queue : DispatchQueue? = .main,
                              progress : @escaping xHandlerApiUploadProgress,
                              success : @escaping xHandlerApiRequestSuccess,
                              failure : @escaping xHandlerApiRequestFailure)
    {
        shared.requestCount += 1
        // 创建请求记录
        let record = xReqRecord.init()
        record.id = shared.requestCount
        record.url = urlStr
        record.method = method
        record.header = header
        record.parameter = parameter
        record.isAlertSuccessMsg = isAlertSuccessMsg
        record.isAlertFailureMsg = isAlertFailureMsg
        record.success = success
        record.failure = failure
        // 添加配置信息
        record.reqConfig = self.getReqConfig()
        record.repConfig = self.getRepConfig()
        shared.requestRecordList.append(record)
        
        // 格式化请求数据
        var fm_url = self.formatterReq(url: urlStr)
        var fm_head = self.formatterReq(header: header)
        var fm_parm = self.formatterReq(parameter: parameter)
        
        // 数据摘要(签名)处理
        if let sign = self.sign(url: fm_url, header: fm_head, parameter: fm_parm) {
            switch record.reqConfig.signPlace {
            case .header:   fm_head[record.reqConfig.signKey] = sign
            case .body:     fm_parm[record.reqConfig.signKey] = sign
            default: break
            }
        }
        
        // GET请求拼接参数到URL中
        if method == .get, fm_parm.count > 0 {
            let getStr = self.formatterGetString(of: fm_parm)
            fm_url = fm_url + "?" + getStr
            // URL编码(先解码再编码，防止2次编码)
            fm_url = fm_url.xToUrlDecodeString() ?? fm_url
            fm_url = fm_url.xToUrlEncodeString() ?? fm_url
            fm_parm.removeAll() // 重置参数对象
        }
        
        // 创建请求体
        Alamofire.upload(multipartFormData: {
            (formData) in
            // 从新命名文件
            let timeStapm = "\(xTimeStamp)"
            let fileName = "iOS_\(name)_\(timeStapm).\(type.type)"
            // 把参数塞到表单里
            for (k, v) in fm_parm {
                guard let obj = v as? String else { continue }
                guard let data = obj.data(using: .utf8) else { continue }
                formData.append(data, withName: k)
            }
            // 把文件塞到表单里
            formData.append(file,
                            withName: name,
                            fileName: fileName,
                            mimeType: type.rawValue)
            
        }, to: fm_url, method: method, headers: fm_head, encodingCompletion: {
            (formDataEncodingResult) in
            // xLog("数据准备完成")
            // 判断表单创建是否完成
            switch formDataEncodingResult {
            case .success(let request, _, _):
                // 初始化上传进度回调
                request.uploadProgress(closure: {
                    (pro) in
                    progress(pro)
                })
                // 校验请求信息、进行请求
                request.validate().responseJSON(queue: queue) {
                    (response) in
                    // 处理请求结果
                    self.check(response: response,
                               record: record)
                }
            case .failure(let error):
                xWarning("表单拼接失败：\(error.localizedDescription)")
                break
            }
        })
    }
}
