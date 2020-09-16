//
//  xInputAlert.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xInputAlert: NSObject {
    
    // MARK: - Open Func
    /// 显示输入提示窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - title: 标题
    ///   - placeholder: 占位符
    ///   - keyboardType: 键盘类型
    ///   - sureTitle: 确定标题
    ///   - cancelTitle: 取消标题
    ///   - sureHandler: 确定回调
    ///   - cancelHandler: 取消回调
    public static func display(from viewController : UIViewController,
                               title : String?,
                               placeholder : String?,
                               keyboardType : UIKeyboardType = .default,
                               sureTitle : String? = "确定",
                               cancelTitle : String? = "取消",
                               sureHandler : @escaping (String) -> Void,
                               cancelHandler : @escaping () -> Void) -> Void
    {
        let alert = UIAlertController.init(title: title,
                                           message: nil,
                                           preferredStyle: .alert)
        // TODO: 输入框
        alert.addTextField {
            (input) in
            input.placeholder = placeholder
            input.keyboardType = keyboardType
        }
        // TODO: 确定按钮
        let sure = UIAlertAction.init(title: sureTitle, style: .default){
            (sender) in
            let str = alert.textFields?.first?.text ?? ""
            sureHandler(str)
        }
        alert.addAction(sure)
        // TODO: 取消按钮
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) {
            (sender) in
            cancelHandler()
        }
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
