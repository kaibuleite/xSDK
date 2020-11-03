//
//  xActionSheet.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xActionSheet: NSObject {
    
    // MARK: - Public Func
    /// 显示选择菜单
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - title: 标题
    ///   - placeholder: 占位符
    ///   - sureTitle: 确定标题
    ///   - cancelTitle: 取消标题
    ///   - sureHandler: 确定回调
    ///   - cancelHandler: 取消回调
    public static func display(from viewController : UIViewController,
                               title : String?,
                               dataArray : [String],
                               cancelTitle : String? = "取消",
                               choose handler1 : @escaping (Int, String) -> Void,
                               cancel handler2 : @escaping () -> Void)
    {
        let actionSheet = UIAlertController.init(title: title,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        // 操作选项
        for (i, title) in dataArray.enumerated() {
            let item = UIAlertAction.init(title: title, style: .default) {
                (sender) in
                handler1(i, title)
            }
            actionSheet.addAction(item)
        }
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) {
            (sender) in
            handler2()
        }
        actionSheet.addAction(cancel)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
