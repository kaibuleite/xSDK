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
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        // 格式化请求数据
        let config = self.formatApiConfig() // 加载配置
        var fm_url = self.formatRequest(urlStr: urlStr)
        var fm_head = self.formatRequest(header: header)
        var fm_parm = self.formatRequest(parameter: parameter)
        if let sign = self.sign(urlStr: fm_url, header: fm_head, parameter: fm_parm) {
            fm_head[config.reqSignKey] = sign
        }
        // GET请求凭借参数到URL中
        if method == .get {
            let getStr = self.formatGetString(of: fm_parm)
            fm_url = fm_url + "?" + getStr
            let chaset = CharacterSet.urlQueryAllowed
            // 处理中文编码
            if let str = fm_url.addingPercentEncoding(withAllowedCharacters: chaset) {
                fm_url = str
            }
            fm_parm = .init()   // 重置参数对象
        }
        // 保存请求记录
        shared.requestCount += 1
        let record = xAPIRecord.init(config: config)
        record.id = shared.requestCount
        record.method = method
        record.url = urlStr
        record.header = header
        record.parameter = parameter
        record.isAlertSuccessMsg = isAlertSuccessMsg
        record.isAlertFailureMsg = isAlertFailureMsg
        record.success = success
        record.failure = failure
        shared.requestRecordList.append(record)
        
        // 创建请求体
        let request = Alamofire.request(fm_url,
                                        method: method,
                                        parameters: fm_parm,
                                        headers: fm_head)
        // 校验请求信息
        request.validate()
        // 进行请求
        request.responseJSON {
            (response) in
            // 处理请求结果
            self.check(record: record,
                       response: response,
                       success: success,
                       failure: failure)
        }
    }
    
    // MARK: - GET请求
    /// GET请求
    public static func get(urlStr : String,
                           header : [String : String]? = nil,
                           parameter : [String : String]?,
                           isAlertSuccessMsg : Bool = false,
                           isAlertFailureMsg : Bool = true,
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .get,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
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
                            success : @escaping xHandlerApiRequestSuccess,
                            failure : @escaping xHandlerApiRequestFailure)
    {
        self.req(urlStr: urlStr,
                 method: .post,
                 header: header,
                 parameter: parameter,
                 isAlertSuccessMsg: isAlertSuccessMsg,
                 isAlertFailureMsg: isAlertFailureMsg,
                 success: success,
                 failure: failure)
    }
    
    // MARK: - 上传文件
    /// 上传文件
    public static func upload(urlStr : String,
                              header : [String : String]? = nil,
                              parameter : [String : Any]?,
                              file : Data,
                              name : String,
                              type : xAPI.xUploadFileType,
                              isAlertSuccessMsg : Bool = false,
                              isAlertFailureMsg : Bool = true,
                              progress : @escaping xHandlerApiUploadProgress,
                              success : @escaping xHandlerApiRequestSuccess,
                              failure : @escaping xHandlerApiRequestFailure)
    {
        // 格式化请求数据
        let config = self.formatApiConfig() // 加载配置
        let fm_url = self.formatRequest(urlStr: urlStr)
        var fm_head = self.formatRequest(header: header)
        let fm_parm = self.formatRequest(parameter: parameter)
        
        if let sign = self.sign(urlStr: fm_url, header: fm_head, parameter: fm_parm) {
            fm_head[config.reqSignKey] = sign
        }
        // 上传不保存请求记录
        shared.requestCount += 1
        let record = xAPIRecord.init(config: config)
        record.id = shared.requestCount
        record.method = .post
        record.url = urlStr
        record.header = header
        record.parameter = parameter
        record.isAlertSuccessMsg = isAlertSuccessMsg
        record.isAlertFailureMsg = isAlertFailureMsg
        record.success = success
        record.failure = failure
        //shared.requestRecordList.append(record)
        
        // 创建请求体
        Alamofire.upload(multipartFormData: {
            (formData) in
            // 把参数塞到表单里
            for (k, v) in fm_parm {
                guard let obj = v as? String else { continue }
                guard let data = obj.data(using: .utf8) else { continue }
                formData.append(data, withName: k)
            }
            // 把文件塞到表单里
            let timeStapm = "\(xTimeStamp)"
            let fileName = "iOS_\(name)_\(timeStapm).\(type.type)"
            formData.append(file, withName: name, fileName: fileName, mimeType: type.rawValue)
            
        }, to: fm_url, method: .post, headers: fm_head, encodingCompletion: {
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
                // 校验请求信息
                request.validate()
                // 进行请求
                request.responseJSON(completionHandler: {
                    (response) in
                    // 处理请求结果
                    self.check(record: record,
                               response: response,
                               success: success,
                               failure: failure)
                })
            case .failure(let error):
                xWarning("表单拼接失败：\(error.localizedDescription)")
                break
            }
        })
    }
}
