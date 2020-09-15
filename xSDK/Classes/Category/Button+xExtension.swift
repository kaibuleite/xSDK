//
//  Button+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

extension UIButton
{
    /// 按钮点击回调
    public typealias xHandlerBtnClick = (UIButton) -> Void
    
    // MARK: - 私有变量
    /// 事件关联Key
    private struct xRuntimeKey {
        /// 按钮点击事件
        static let btnClick = UnsafeRawPointer.init(bitPattern: "xButtonClickEvent".hashValue)
    }
    /// 按钮点击回调
    private var clickHandler : xHandlerBtnClick?
    {
        set {
            /* 关联回调对象
             objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
             object      :表示关联者，是一个对象，变量名理所当然也是object
             key         :获取被关联者的索引key
             value       :被关联者，这里是一个block
             policy      :关联时采用的协议，有assign，retain，copy
             */
            let key = UIButton.xRuntimeKey.btnClick!
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            let key = UIButton.xRuntimeKey.btnClick!
            let value = objc_getAssociatedObject(self, key) as? xHandlerBtnClick
            return value
        }
    }
    
    // MARK: - 按钮事件
    /// 添加按钮事件
    /// - Parameter handler: 按钮回调
    public func x_addClick(handler : @escaping xHandlerBtnClick) -> Void
    {
        self.clickHandler = handler
        // 重新绑定按钮系统事件
        self.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    /// 移除事件关联
    public func x_removeClickHandler()
    {
        self.clickHandler = nil
        /*
         objc_removeAssociatedObjects(self)
         使用该函数可以断开所有关联。
         通常情况下不建议使用这个函数，因为他会断开所有关联。
         只有在需要把对象恢复到“原始状态”的时候才会使用这个函数。
         */
    }
    /// 执行事件
    public func x_executeClickHandler()
    {
        self.btnClick()
    }
    
    /// 按钮点击
    @objc private func btnClick()
    {
        self.clickHandler?(self)
    }
}
