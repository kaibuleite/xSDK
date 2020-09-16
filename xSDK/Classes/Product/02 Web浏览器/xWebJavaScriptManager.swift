//
//  xWebJavaScriptManager.swift
//  xSDK
//
//  Created by Mac on 2020/9/16.
//

import UIKit
import WebKit

public class xWebJavaScriptManager: NSObject, WKScriptMessageHandler {

    // MARK: - Handler
    /// 收到JS事件回调
    public typealias xHandlerReceiveWebJS = (String) -> Void
    
    // MARK: - Private Property
    /// 弱引用浏览器
    weak var xWeb : xWebViewController?
    /// 回调
    private var handler : xHandlerReceiveWebJS?
    
    // MARK: - 内存释放
    deinit {
        self.xWeb = nil
        self.handler = nil
        x_log("🗑 xWebJavaScriptManager")
    }
    
    // MARK: - Public Func
    /// 添加收到JS事件回调
    public func addReceiveWebJS(handler : @escaping xHandlerReceiveWebJS)
    {
        self.handler = handler
    }
    
    // MARK: - WKScriptMessageHandler
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        
        let name = message.name
        // message.body
        self.handler?(name)
    }
}
