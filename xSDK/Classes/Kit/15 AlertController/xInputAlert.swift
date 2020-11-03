//
//  xInputAlert.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xInputAlert: NSObject {
    
    // MARK: - Public Func
    /// 显示输入弹窗
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
                               sure handler1 : @escaping (String) -> Void,
                               cancel handler2 : @escaping () -> Void)
    {
        let alert = UIAlertController.init(title: title,
                                           message: nil,
                                           preferredStyle: .alert)
        // 输入框
        alert.addTextField {
            (input) in
            input.placeholder = placeholder
            input.keyboardType = keyboardType
        }
        // 确定
        let sure = UIAlertAction.init(title: sureTitle, style: .default){
            (sender) in
            let str = alert.textFields?.first?.text ?? ""
            handler1(str)
        }
        alert.addAction(sure)
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) {
            (sender) in
            handler2()
        }
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
