//
//  xAPI.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import Alamofire

open class xAPI: NSObject {
    
    // MARK: - Enum
    /// 请求类型枚举
    public enum xRequestMethod {
        case get
        case post
        case upload
    }
    /// 上传文件类型枚举
    public enum xUploadFileTypeEnum : String {
        // 图片
        case image = "image/png"
        case jpeg, jpg = "image/jpeg"
        case gif = "image/gif"
        // 多媒体
        case mp3 = "audio/mp3"
        case mp4, mpg4, m4vmp4v = "video/mp4"
        case mov = "video/mov"
        // 文本
        case txt = "text/plain"
    }

    // MARK: - Handler
    /// 请求成功回调
    public typealias xHandlerApiRequestSuccess = (Any?) -> Void
    /// 请求失败回调
    public typealias xHandlerApiRequestFailure = (String) -> Void
    /// 上传过程回调
    public typealias xHandlerApiUploadProgress = (Progress) -> Void
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xAPI()
    private override init() { }
    /// 请求次数
    var requestCount = 0
    /// 请求记录
    var requestRecordList = [xAPIRecord]() {
        didSet {
            //xLog("🍥🍥🍥 ReqCount = \(self.requestRecordList.count)   🍥🍥🍥")
        }
    }
    /// 出错Html提示
//    let errorHtmlWeb = MyWebBrowserViewController.quickInstancetype()
    let errorHtmlWeb = xViewController.quickInstancetype()
    
    
    
    // MARK: - Open Func
    // TODO: 参数处理
    /// URL前缀
    open class func urlPrefix() -> String
    {
        return ""
    }
    /// 格式化接口配置
    open class func formatApiConfig() -> xAPIConfig
    {
        return xAPIConfig()
    }
    /// 格式化Api请求URL
    open class func formatRequest(urlStr : String) -> String
    {
        // 关掉键盘
        x_getKeyWindow()?.endEditing(true)
        var url = urlStr
        if urlStr.hasPrefix("http") == false {
            url = self.urlPrefix() + urlStr
        }
        // 转码
        let chaset = CharacterSet.urlQueryAllowed
        if let ret = url.addingPercentEncoding(withAllowedCharacters: chaset) {
            return ret
        }
        return url
    }
    /// 格式化Api头部参数
    open class func formatRequest(header: [String : String]?) -> [String : String]
    {
        let head = header ?? [String : String]()
        return head
    }
    /// 格式化Api请求参数
    open class func formatRequest(parameter : [String : Any]?) -> [String : Any]
    {
        let parm = parameter ?? [String : Any]()
        return parm
    }
    /// API接口加签
    open class func sign(urlStr : String,
                         header: [String : String],
                         parameter : [String : Any]) -> String?
    {
        return nil
    }
    
    // TODO: 调试信息
    /// 显示调试网页
    open class func showDebugWeb(html : String)
    {
        guard let root = x_getKeyWindow()?.rootViewController else { return }
        
//        if let web = shared.errorHtmlWeb {
//            web.html = html
//            let nvc = xNavigationController.init(rootViewController: web)
//            nvc.navigationBar.isHidden = true   // 不使用nvc会导致视图控制器action冲突
//            root.present(nvc, animated: true, completion: nil)
//        }
        
    }
    
    // MARK: - Public Func
    // TODO: 数据请求
    /// GET请求
    public static func get(urlStr : String,
                           header : [String : String]? = nil,
                           parameter : [String : String]?,
                           isAlertSuccessMsg : Bool = false,
                           isAlertFailureMsg : Bool = true,
                           success : @escaping xHandlerApiRequestSuccess,
                           failure : @escaping xHandlerApiRequestFailure)
    {
        // 格式化请求数据
        let config = self.formatApiConfig() // 加载配置
        var fm_url = self.formatRequest(urlStr: urlStr)
        var fm_head = self.formatRequest(header: header)
        let fm_parm = self.formatRequest(parameter: parameter)
        
        if let sign = self.sign(urlStr: fm_url, header: fm_head, parameter: fm_parm) {
            fm_head[config.reqSignKey] = sign
        }
        // 参数中文编码
        let getStr = self.formatGetString(of: fm_parm)
        fm_url = fm_url + "?" + getStr
        let chaset = CharacterSet.urlQueryAllowed
        if let str = fm_url.addingPercentEncoding(withAllowedCharacters: chaset) {
            fm_url = str
        }
        // 保存请求记录
        shared.requestCount += 1
        let record = xAPIRecord.init(config: config)
        record.id = shared.requestCount
        record.method = .get
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
                                        method: .get,
                                        parameters: nil,
                                        headers: fm_head)
        // 校验请求信息
        request.validate()
        // 显示遮罩
        xRequestMaskViewController.display()
        // 进行请求
        request.responseJSON {
            (response) in
            // 处理请求结果
            self.check(record: record, response: response, success: success, failure: failure)
        }
    }
     
    /// POS请求
    public static func post(urlStr : String,
                            header : [String : String]? = nil,
                            parameter : [String : Any]?,
                            isAlertSuccessMsg : Bool = false,
                            isAlertFailureMsg : Bool = true,
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
        // 保存请求记录
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
        shared.requestRecordList.append(record)
        
        // 创建请求体
        let request = Alamofire.request(fm_url,
                                        method: .post,
                                        parameters: fm_parm,
                                        headers: fm_head)
        // 校验请求信息
        request.validate()
        // 显示遮罩
        xRequestMaskViewController.display()
        // 进行请求
        request.responseJSON {
            (response) in
            // 处理请求结果
            self.check(record: record, response: response, success: success, failure: failure)
        }
    }
    /// 上传文件
    public static func upload(urlStr : String,
                              header : [String : String]? = nil,
                              parameter : [String : Any]?,
                              file : Data,
                              name : String,
                              type : xAPI.xUploadFileTypeEnum,
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
        record.method = .upload
        record.url = urlStr
        record.header = header
        record.parameter = parameter
        record.isAlertSuccessMsg = isAlertSuccessMsg
        record.isAlertFailureMsg = isAlertFailureMsg
        
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
            let timeStapm = "\(Int(x_getTimeStamp()))"
            let fileName = name + "_iOS_" + "_" + "\(timeStapm)" + ".jpg"
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
                // 显示遮罩
                xRequestMaskViewController.display()
                // 进行请求
                request.responseJSON(completionHandler: {
                    (response) in
                    // 处理请求结果
                    self.check(record: record, response: response, success: success, failure: failure)
                })
            case .failure(let error):
                x_warning("表单拼接失败：\(error.localizedDescription)")
                break
            }
        })
    }
    
    // TODO: 返回数据校验
    /// 默认判断逻辑，校验返回结果
    public static func check(record : xAPIRecord,
                             response : DataResponse<Any>,
                             success : @escaping xHandlerApiRequestSuccess,
                             failure : @escaping xHandlerApiRequestFailure)
    {
        defer {
            xRequestMaskViewController.dismiss()
            xRequestMaskViewController.recoverDefaultStyle()
            for (i, v) in shared.requestRecordList.enumerated() {
                guard v.id == record.id else { continue }
                shared.requestRecordList.remove(at: i)
                break
            }
        }
        // 响应成功
        if response.result.isSuccess {
            if let info = response.result.value as? [String : Any] {
                self.returnResponse(record: record,
                                    info: info,
                                    success: success,
                                    failure: failure)
            }
            else {
                self.logDataError(record: record,
                                  isReqSuccess: true,
                                  response: response)
                failure("接口返回的Data解析出错0")
            }
            return
        }
        // 响应失败
        if let error = response.error {
            let code = (error as NSError).code
            let config = record.config
            // 系统问题
            switch code {
            case config.failureNetworkBrokenCode:
                self.logNetworkBroken(of: response)
                failure("🌐 断网了")
                return
            default:
                break
            }
        }
        guard let data = response.data else {
            self.logDataError(record: record,
                              isReqSuccess: false,
                              response: response)
            failure("接口返回的Data解析出错1")
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            self.logDataError(record: record,
                              isReqSuccess: false,
                              response: response)
            failure("接口返回的Data解析出错2")
            return
        }
        guard let info = json as? [String : Any] else {
            self.logDataError(record: record,
                              isReqSuccess: false,
                              response: response)
            failure("接口返回的Data解析出错3")
            return
        }
        // 排查不出错误，而且数据解析成功，当成功处理
        self.returnResponse(record: record,
                            info: info,
                            success: success,
                            failure: failure)
    }
    
    /// 响应数据处理
    public static func returnResponse(record : xAPIRecord,
                                      info : [String : Any],
                                      success : @escaping xHandlerApiRequestSuccess,
                                      failure : @escaping xHandlerApiRequestFailure)
    {
        let config = record.config
        let code = info[config.repCodeKey] as? Int ?? config.failureCode
        // 弹出提示
        let msg = info[config.repMsgKey] as? String ?? ""
        // 状态判断
        if code == config.successCode {
            if record.isAlertSuccessMsg {
                x_alert(message: msg)
            }
            // 成功回调
            let result = info[config.repDataKey]
            success(result)
        }
        else {
            if record.isAlertFailureMsg {
                x_alert(message: msg)
            }
            // 失败回调
            self.logApiCodeError(record: record, info: info)
            failure(msg)
            // 重新登录
            if code == config.failureUserTokenInvalidCode {
                NotificationCenter.default.post(name: x_NotificationReLogin, object: nil)
                return
            }
            for str in config.reLoginMsgArray {
                guard str == msg else { continue }
                NotificationCenter.default.post(name: x_NotificationReLogin, object: nil)
                return
            }
        }
    }
    
    // TODO: 格式化字符串
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
    
    // TODO: 错误日志打印
    /// 网络错误
    public static func logNetworkBroken(of response : DataResponse<Any>)
    {
        x_warning("网络错误")
        x_log("************************************")
        x_log("\(response.result)")
        x_log("************************************")
    }
    /// Api逻辑错误
    public static func logApiCodeError(record : xAPIRecord?,
                                       info : [String : Any])
    {
        x_warning("API Code 错误")
        x_log("************************************")
        x_log("\(info)")
        if let obj = record {
            x_log("接口地址：\(obj.url)")
            x_log("GET参数：\(self.formatGetString(of: obj.parameter))")
            x_log("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        x_log("************************************")
    }
    /// 数据解析错误
    public static func logDataError(record : xAPIRecord?,
                                    isReqSuccess : Bool,
                                    response : DataResponse<Any>)
    {
        x_warning("API请求\(isReqSuccess ? "成功" : "失败")，数据解析失败")
        x_log("************************************")
        // NSURLErrorTimedOut
        if let obj = record {
            x_log("接口地址：\(obj.url)")
            x_log("GET参数：\(self.formatGetString(of: obj.parameter))")
            x_log("POST参数：\(self.formatPostString(of: obj.parameter))")
        }
        x_log(response.error?.localizedDescription ?? "")
        x_log("************************************")
        guard let data = response.data else { return }
        guard let html = String.init(data: data, encoding: .utf8) else { return }
        self.showDebugWeb(html: html)
    }
}
