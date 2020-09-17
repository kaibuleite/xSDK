//
//  xActionSheet.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

public class xActionSheet: NSObject {
    
    // MARK: - Open Func
    /// 显示选择提示窗
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
                               itemHandler : @escaping (Int, String) -> Void,
                               cancelHandler : @escaping () -> Void) -> Void
    {
        let actionSheet = UIAlertController.init(title: title,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        // 操作选项
        for (i, title) in dataArray.enumerated() {
            let item = UIAlertAction.init(title: title, style: .default) {
                (sender) in
                itemHandler(i, title)
            }
            actionSheet.addAction(item)
        }
        // 取消
        let cancel = UIAlertAction.init(title: cancelTitle, style: .cancel) {
            (sender) in
            cancelHandler()
        }
        actionSheet.addAction(cancel)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
