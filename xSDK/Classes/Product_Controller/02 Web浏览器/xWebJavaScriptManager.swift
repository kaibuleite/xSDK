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
    public typealias xHandlerReceiveWebJS = (String, WKScriptMessage) -> Void
    
    // MARK: - Private Property
    /// 弱引用浏览器
    weak var xWeb : xWebViewController?
    /// 回调
    var handler : xHandlerReceiveWebJS?
    
    // MARK: - 内存释放
    deinit {
        self.xWeb = nil
        self.handler = nil
        xLog("🗑 xWebJavaScriptManager")
    }
    
    // MARK: - WKScriptMessageHandler
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        
        let name = message.name
        let msg = message
        // message.body
        self.handler?(name, msg)
    }
}
