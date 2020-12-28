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
    public enum xUploadFileType : String {
        // 图片
        case png = "image/png"
        case jpeg, jpg = "image/jpeg"
        case gif = "image/gif"
        // 多媒体
        case mp3 = "audio/mp3"
        case mp4, mpg4, m4vmp4v = "video/mp4"
        case mov = "video/mov"
        // 文本
        case txt = "text/plain"
        
        /// 类型
        var type : String {
            switch self {
            case .png:  return "png"
            case .jpg:  return "jpg"
            case .jpeg: return "jpeg"
            case .gif:  return "gif"
            case .mp3:  return "mp3"
            case .mp4:  return "mp4"
            case .mpg4: return "mp4"
            case .m4vmp4v:  return "mp4"
            case .mov:  return "mov"
            case .txt:  return "txt"
            }
        }
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
    /// 错误提示浏览器
    let errWeb = xWebViewController.quickInstancetype()

    // MARK: - Private Property
    /// 请求次数
    var requestCount = 0
    /// 请求记录
    var requestRecordList = [xAPIRecord]() {
        didSet {
            //xLog("🍥🍥🍥 ReqCount = \(self.requestRecordList.count)   🍥🍥🍥")
        }
    }
    
    // MARK: - Open Func
    // TODO: 参数处理
    /// 格式化接口配置
    open class func formatApiConfig() -> xAPIConfig
    {
        return xAPIConfig()
    }
    /// URL前缀
    open class func urlPrefix() -> String
    {
        return "API前缀"
    }
    /// 格式化Api请求URL
    open class func formatRequest(urlStr : String) -> String
    {
        // 关掉键盘
        xKeyWindow?.endEditing(true)
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
    
    // TODO: 解析响应数据
    /// 用默认风格（code，msg，data）解析响应数据
    /// - Parameter data: 响应数据
    /// - Returns: 解析结果
    open class func formatterDefaultStyleResponseData(_ data : Any,
                                                      record : xAPIRecord) -> (status: Bool, data: Any?)
    {
        guard let obj = data as? Data else {
            return (false, data)
        }
        // 解析JSON
        guard let json = try? JSONSerialization.jsonObject(with: obj, options: .mutableContainers) else {
            return (false, data)
        }
        guard let dict = json as? [String : Any] else {
            return (false, data)
        }
        // 结果处理
        let config = record.config
        let code = dict[config.repCodeKey] as? Int ?? config.failureCode
        let msg = dict[config.repMsgKey] as? String ?? ""
        let result = dict[config.repDataKey]
        if code == config.successCode {
            // 状态正常
            if record.isAlertSuccessMsg {
                xMessageAlert.display(message: msg)
            }
        }
        else {
            // 状态异常
            if record.isAlertFailureMsg {
                xMessageAlert.display(message: msg)
            }
            // 重新登录
            if code == config.failureCodeUserTokenInvalid {
                NotificationCenter.default.post(name: xNotificationReLogin, object: nil)
            }
            else {
                for str in config.reLoginMsgArray {
                    guard str == msg else { continue }
                    NotificationCenter.default.post(name: xNotificationReLogin, object: nil)
                    break
                }
            }
            // 打印出错日志
            self.logApiCodeError(record: record, info: dict)
            
        }
        return (true, result)
    }
    
    /// 用 Restful 风格（直接传data，可能为 arr，dict，str...）解析响应数据
    /// - Parameter data: 响应数据
    /// - Returns: 解析结果
    open class func formatterRestfulStyleResponseData(_ data : Any,
                                                      record : xAPIRecord) -> (status: Bool, data: Any?)
    {
        if let dict = data as? [String : Any] {
            return (true, dict)
        }
        else
        if let arr = data as? [Any] {
            return (true, arr)
        }
        else
        if let str = data as? String {
            return (true, str)
        }
        else {
            xWarning("未知的 Restful 格式")
            xLog(data)
            return (false, data)
        }
    }
    
    /// 用默认风格（code，msg，data）解析响应数据
    /// - Parameter data: 响应数据
    /// - Returns: 解析结果
    open class func formatterOtherStyleResponseData(_ data : Any,
                                                    record : xAPIRecord) -> (status: Bool, data: Any?)
    {
        return (false, data)
    }
    
    // TODO: 错误回收
    /// 尝试捕获响应失败后的数据 状态码可参考 https://blog.csdn.net/lyyybz/article/details/53257270
    /// - Parameters:
    ///   - code: 出错码
    ///   - data: 回收数据
    /// - Returns: 捕获结果
    open class func tryCatchResponseError(code : Int,
                                          data : Any?) -> Bool
    {
        switch code {
        case 400:   // 逻辑错误
            guard let obj = data as? Data else { return false }
            guard let json = try? JSONSerialization.jsonObject(with: obj, options: .mutableContainers) else { return false }
            if let dict = json as? [String : Any] {
                if let msg = dict["msg"] as? String {
                    xMessageAlert.display(message: msg)
                }
            }
            return false
        default:
            return true
        }
    }
    /// 显示调试网页
    open class func showDebugWeb(html : String)
    {
        guard html.xContains(subStr: "<html") else {
            xWarning("不是HTML文本")
            return
        }
        guard let win = xKeyWindow else { return }
        shared.errWeb.view.removeFromSuperview()
        shared.errWeb.view.frame = win.bounds
        win.addSubview(shared.errWeb.view)
        shared.errWeb.load(html: html)
        shared.errWeb.isShowCloseBtn = true
        shared.errWeb.addClickCloseBtn {
            (sender) in
            // 手动控制关闭
            shared.errWeb.view.removeFromSuperview()
        }
    }
    
}
