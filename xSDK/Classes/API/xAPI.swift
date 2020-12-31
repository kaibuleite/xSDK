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
    /// URL前缀
    open class func urlPrefix() -> String
    {
        return "API前缀"
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
    /// 响应数据处理
    open class func analysisResponseData(_ data : Any?,
                                         record : xAPIRecord)
    {
        if let obj = data as? [String : Any] {
            self.handlerResponseDictionaryAnalysis(obj, record: record)
        }
        else
        if let obj = data as? [Any] {
            self.handlerResponseArrayAnalysis(obj, record: record)
        }
        else
        if let obj = data as? String {
            self.handlerResponseStringAnalysis(obj, record: record)
        }
        else
        if let obj = data as? NSNumber {
            self.handlerResponseNumberAnalysis(obj, record: record)
        }
        else
        if let obj = data as? Float {
            self.handlerResponseFloatAnalysis(obj, record: record)
        }
        else
        if let obj = data as? Data {
            // 尝试解析JSON
            guard let json = try? JSONSerialization.jsonObject(with: obj, options: .mutableContainers) else {
                self.logCheckDataError(data: obj, record: record)
                record.failure?("数据解析失败")
                return
            }
            xLog("JSON解析成功，重新处理相应数据")
            self.analysisResponseData(json, record: record)
        }
        else
        if let obj = data {
            self.handlerResponseOtherAnalysis(obj, record: record)
        }
        else {
            self.logCheckDataError(data: data, record: record)
            record.failure?("数据解析失败")
        }
    }
    
    /// 处理字典解析结果
    /// - Parameters:
    ///   - dict: 字典数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseDictionaryAnalysis(_ dict : [String : Any],
                                                      record : xAPIRecord) -> Bool
    {
        // 结果处理
        let config = record.config
        guard let obj = dict[config.repCodeKey] else {
            // Restful 模式
            return self.handlerResponseRestfulDictionaryAnalysis(dict, record: record)
        }
        
        // code msg data组合模式
        var code = config.failureCode
        if let str = obj as? String {
            code = str.xToInt()
        }
        else
        if let num = obj as? Int {
            code = num
        }
        let msg = dict[config.repMsgKey] as? String ?? ""
        if code == config.successCode {
            // 状态正常
            if record.isAlertSuccessMsg {
                xMessageAlert.display(message: msg)
            }
            let result = dict[config.repDataKey]
            record.success?(result)
            return true
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
            self.logApiCodeError(data: dict, record: record)
            record.failure?(msg)
            return false
        }
    }
    /// 处理Restful字典解析结果
    /// - Parameters:
    ///   - dict: 字典数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseRestfulDictionaryAnalysis(_ dict : [String : Any],
                                                             record : xAPIRecord) -> Bool
    {
        return false
    }
    /// 处理数组解析结果
    /// - Parameters:
    ///   - arr: 数组数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseArrayAnalysis(_ arr : [Any],
                                                 record : xAPIRecord) -> Bool
    {
        record.failure?("Array类型没有指定处理方式")
        return false
    }
    /// 处理字符串解析结果
    /// - Parameters:
    ///   - str: 字符串数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseStringAnalysis(_ str : String,
                                                  record : xAPIRecord) -> Bool
    {
        record.failure?("String类型没有指定处理方式")
        return false
    }
    /// 处理数字解析结果
    /// - Parameters:
    ///   - num: 数字数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseNumberAnalysis(_ num : NSNumber,
                                                  record : xAPIRecord) -> Bool
    {
        record.failure?("Number类型没有指定处理方式")
        return false
    }
    /// 处理浮点数解析结果
    /// - Parameters:
    ///   - float: 浮点数据
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseFloatAnalysis(_ float : Float,
                                                 record : xAPIRecord) -> Bool
    {
        record.failure?("Float类型没有指定处理方式")
        return false
    }
    /// 处理其他类型解析结果
    /// - Parameters:
    ///   - obj: 其他类型
    ///   - record: API记录
    @discardableResult
    open class func handlerResponseOtherAnalysis(_ obj : Any,
                                                 record : xAPIRecord) -> Bool
    {
        record.failure?("未知类型没有指定处理方式")
        return false
    }
    
    // TODO: 响应失败操作
    /// 根据响应状态码决定是否中断响应失败后续处理
    /// 状态码可参考 https://blog.csdn.net/lyyybz/article/details/53257270
    /// - Parameters:
    ///   - statusCode: 出错码
    /// - Returns: 判断结果
    open class func breakResponseFailure(statusCode : Int) -> Bool
    {
        switch statusCode {
        case 400:   // 逻辑错误
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
