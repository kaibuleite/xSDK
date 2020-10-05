//
//  xGlobalFunction.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

// MARK: - 获取数组中指定数据的编号
/// 获取数组中指定数据的编号,数组需要统一数据类型,且查找类型也要正确
/// - Parameters:
///   - obj: 要查找的对象数据
///   - array: 要查找的数组
/// - Returns: 编号
public func x_findIndex<T : Equatable>(of obj : T,
                                       in array : [T]) -> Int?
{
    for (index, value) in array.enumerated() {
        if value == obj {
            return index
        }
    }
    return nil
}

// MARK: - 获取对象类名
/// 获取对象类名(不带命名空间)
/// - Parameter object: 对象
/// - Returns: 类名
public func x_getClassName(withObject object : AnyObject,
                           isShowSpace : Bool = false) -> String?
{
    guard let aClass = object.classForCoder else {
        x_warning("无法获取类名")
        return nil
    }
    let classStr = NSStringFromClass(aClass)
    let arr = classStr.components(separatedBy: ".")
    // 获取的类名格式为 命名空间.类名
    var spaceName = ""
    var className = ""
    if arr.count == 2 {
        // 直接拆分数组
        spaceName = arr[0]
        className = arr[1]
    }
    else {
        // 从info.plist读取命名空间并删掉
        let bundle = Bundle.init(for: aClass)
        guard let info = bundle.infoDictionary else { return nil }
        guard let name = info["CFBundleExecutable"] as? String else { return nil }
        spaceName = name
        className = classStr.replacingOccurrences(of: spaceName, with: "")
        className = className.replacingOccurrences(of: ".", with: "")
    }
    if isShowSpace == true {
        return "\(spaceName).\(className)"
    }
    return className
}

// MARK: - 拨打电话
/// 拨打电话
public func x_call(phone : String)
{
    let str = "telprompt://" + phone
    guard let url = URL.init(string: str) else {
        return
    }
    if UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.openURL(url)
    }
}

// MARK: - 显示提示标签
/// 显示提示标签
public func x_alert(message : String,
                    duration : Double = 0) -> Void
{
    guard message.count > 0 else { return }
    // 移除旧控件
    guard let win = x_KeyWindow else { return }
    let tag = 124090    // 固定tag
    win.viewWithTag(tag)?.removeFromSuperview()
    // 创建提示标签
    let lbl = UILabel.init()
    lbl.tag = tag
    lbl.numberOfLines = 0
    lbl.preferredMaxLayoutWidth = x_ScreenWidth - 100
    lbl.text = message
    lbl.textAlignment = NSTextAlignment.center
    lbl.textColor = UIColor.white
    lbl.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
    lbl.layer.masksToBounds = true
    lbl.layer.cornerRadius = 5
    lbl.alpha = 1
    // 修改坐标
    var frame = CGRect.init(origin: CGPoint.zero, size: lbl.x_getContentSize())
    frame.size.width += 16
    frame.size.height += 10
    lbl.frame = frame
    lbl.center = CGPoint.init(x: win.bounds.size.width / 2.0, y: win.bounds.size.height / 2.0)
    win.addSubview(lbl)
    // 设置动画
    var time = duration
    if duration == 0 {
        time = 2.0 + 0.05 * Double(message.count)
    }
    UIView.animate(withDuration: time, animations: {
        lbl.alpha = 0
    }, completion: {
        (finished) in
        lbl.removeFromSuperview()
    })
}

// MARK: - 对象锁
/// 对象锁
/// - Parameters:
///   - obj: 对象
///   - handler: 回调事件
public func x_lock(_ obj: AnyObject,
                   handler: () -> ())
{
    objc_sync_enter(obj)
    handler()
    objc_sync_exit(obj)
}

// MARK: - 根据设计高度计算实际宽高
/// 根据设计高度计算实际高度
/// - Parameter h: 设计高度
/// - Returns: 实际高度
public func x_getRealHeight(withDesignHeight h : CGFloat) -> CGFloat
{
    let ret = h / 375.0 * x_ScreenWidth
    return ret
}
/// 根据设计宽度计算实际宽度
/// - Parameter w: 设计宽度
/// - Returns: 实际宽度
public func x_getRealWidth(withDesignWidth w : CGFloat) -> CGFloat
{
    let ret = w / 375.0 * x_ScreenWidth
    return ret
}
