//
//  xAlert.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xAlert: NSObject {
    
    // MARK: - Public Func
    /// 显示弹窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - title: 标题
    ///   - message: 提示内容
    ///   - itemSure: 确定标题
    ///   - itemCancel: 取消标题
    ///   - sure: 确定回调
    ///   - cancel: 取消回调
    public static func display(from viewController : UIViewController,
                               title : String?,
                               message : String?,
                               sureTitle : String? = "确定",
                               cancelTitle : String? = "取消",
                               sureHandler : @escaping () -> Void,
                               cancelHandler : @escaping () -> Void)
    {
        let alert = UIAlertController.init(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        // 确定
        let sure = UIAlertAction.init(title: sureTitle, style: .default) {
            (sender) in
            sureHandler()
        }
        alert.addAction(sure)
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) {
            (sender) in
            cancelHandler()
        }
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
