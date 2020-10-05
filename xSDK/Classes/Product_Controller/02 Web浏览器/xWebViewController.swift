//
//  xWebViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/16.
//

import UIKit
import WebKit

/// 方法详情可以参考 https://www.jianshu.com/p/747b7a1dfd06
open class xWebViewController: xViewController, WKNavigationDelegate {

    // MARK: - IBOutlet Property
    /// 关闭按钮
    @IBOutlet weak var closeBtn: UIButton!
    
    // MARK: - IBInspectable Property
    /// 是否显示关闭按钮
    @IBInspectable public var isShowCloseBtn : Bool = true
    /// 是否显示加载进度条(默认显示)
    @IBInspectable public var isShowLoadingProgress : Bool = true
    /// 进度条颜色
    @IBInspectable public var loadingProgressColor : UIColor = UIColor.blue.withAlphaComponent(0.5) {
        didSet {
            self.progressView.progressTintColor = self.loadingProgressColor
        }
    }
    
    // MARK: - Public Property
    /// JavaScript 管理器(无主引用，管理器依托于WebController)
    public let jsMgr = xWebJavaScriptManager()
    
    // MARK: - Private Property
    /// js事件名列表
    private var jsNameArray = [String]()
    /// 进度条
    private let progressView = UIProgressView()
    /// 浏览器主体
    private let web = WKWebView.init(frame: .zero, configuration: xWebViewController.getWebConfig())
    
    // MARK: - 内存释放
    deinit {
        self.removeJavaScriptMethod()
        self.removeObserver()
        self.web.uiDelegate = nil
        self.web.navigationDelegate = nil
    }
    
    // MARK: - Open Override Func
    open override class func quickInstancetype() -> Self {
        let vc = xWebViewController.xNew(storyboard: "xWebViewController")
        return vc as! Self
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.closeBtn.isHidden = !self.isShowCloseBtn
        self.jsMgr.xWeb = self
        // web
        self.web.allowsBackForwardNavigationGestures = true // 是否支持手势返回
        self.web.navigationDelegate = self
        self.safeView?.addSubview(web)
        // 进度条
        self.progressView.progressTintColor = self.loadingProgressColor
        self.progressView.trackTintColor = .groupTableViewBackground
        self.progressView.isHidden = true
        self.safeView?.addSubview(self.progressView)
        self.safeView?.bringSubviewToFront(self.closeBtn)
        // 其他
        self.addObserver()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = self.view.bounds
        self.web.frame = frame
        frame.size.height = 2
        self.progressView.frame = frame
    }
    open override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?)
    {
        if keyPath == "estimatedProgress" {
            let progress = Float(self.web.estimatedProgress)
            self.progressView.progress = progress
        }
    }
    
    // MARK: - Open Func
    /// WEB配置
    open class func getWebConfig() -> WKWebViewConfiguration
    {
        let config = WKWebViewConfiguration.init()
        config.preferences.javaScriptEnabled = true
        /*
        // 是否允许播放 AirPlay
        config.allowsAirPlayForMediaPlayback = true
        // 媒体播放的类型 (audio/video)
        config.mediaTypesRequiringUserActionForPlayback = .video
        // 媒体自动播放
        config.requiresUserActionForMediaPlayback = true
        // 是否允许播放 AirPlay
        config.allowsAirPlayForMediaPlayback = true
        // 媒体播放是否可以全屏控制
        config.allowsInlineMediaPlayback = true
        // 可用允许触发网页 JavaScript
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
         */
        return config
    }
    /// 调用JS
    open func actJavaScriptMethod() { }
    
    // MARK: - Public Func
    /// 加载URL地址
    /// - Parameter str: 地址
    public func load(url str: String)
    {
        guard let url = URL.init(string: str)  else { return }
        let req = URLRequest.init(url: url)
        self.web.load(req)
    }
    /// 加载HTML字符串
    /// - Parameter html: HTML字符串
    public func load(html : String)
    {
        self.web.loadHTMLString(html, baseURL: nil)
    }
    /// 刷新当前网页
    public func reload()
    {
        self.web.reload()
    }
    /// 清理浏览器缓存
    public func clearCache()
    {
        //allWebsiteDataTypes清除所有缓存
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let timeStamp = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: timeStamp) {
            xLog("缓存清理完成")
        }
    }
    /// 添加 JS 事件
    public func addJavaScriptMethod(list : [String])
    {
        self.removeJavaScriptMethod()
        self.jsNameArray = list
        let uc = self.web.configuration.userContentController
        self.jsNameArray.forEach {
            [unowned self] (name) in
            uc.add(self.jsMgr, name: name)
        }
    }

    // MARK: - IBAction Private Func
    @IBAction func closeBtnClick() {
        guard let nvc = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        guard let root = nvc.children.first else {
            xWarning("空的导航栏？？？？")
            self.dismiss(animated: true, completion: nil)
            return
        }
        if root == self {
            self.dismiss(animated: true, completion: nil)
        } else {
            nvc.popViewController(animated: true)
        }
    }
    
    // MARK: - Private Func
    /// 移除 JS 事件
    private func removeJavaScriptMethod()
    {
        let uc = self.web.configuration.userContentController
        self.jsNameArray.forEach {
            (name) in
            uc.removeScriptMessageHandler(forName: name)
        }
        self.jsNameArray.removeAll()
    }
    /// 添加观察者
    private func addObserver()
    {
        self.web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    /// 移除观察者
    private func removeObserver()
    {
        self.web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - WKNavigationDelegate
    /// 准备加载页面
    public func webView(_ webView: WKWebView,
                        didStartProvisionalNavigation navigation: WKNavigation!) {
        xLog("准备加载页面")
        // 判断是否显示加载进度条
        if self.isShowLoadingProgress {
            self.progressView.isHidden = false
            self.progressView.progress = 0 // 重置进度
        }
    }
    
    /// 内容开始加载(view的过渡动画可在此方法中加载)
    public func webView(_ webView: WKWebView,
                        didCommit navigation: WKNavigation!) {
        xLog("内容开始加载")
    }
    
    /// 导航过程中发生错误时调用(跳转失败)
    public func webView(_ webView: WKWebView,
                        didFail navigation: WKNavigation!,
                        withError error: Error) {
        xLog("导航发生错误 \(error.localizedDescription)")
        self.progressView.isHidden = true  // 隐藏加载进度条
    }
    
    /// Web视图加载内容时发生错误时调用(没有网络，加载地址)
    public func webView(_ webView: WKWebView,
                        didFailProvisionalNavigation navigation: WKNavigation!,
                        withError error: Error) {
        xLog("网页加载内容时发生错误时 \(error.localizedDescription)")
        self.progressView.isHidden = true  // 隐藏加载进度条
    }
    
    /// 服务器重定向，主机地址被重定向时调用
    public func webView(_ webView: WKWebView,
                        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        xLog("网页重定向")
    }
    
    /// 网页加载完成时
    public func webView(_ webView: WKWebView,
                        didFinish navigation: WKNavigation!) {
        xLog("网页加载完成")
        self.progressView.isHidden = true  // 隐藏加载进度条
        // 可以在此处调用 JS
        self.actJavaScriptMethod()
    }
}
