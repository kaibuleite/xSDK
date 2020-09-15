//
//  xGlobalFunction.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

// MARK: - 获取 KeyWindow
/// 获取 KeyWindow
/// - Returns: KeyWindow
public func x_getKeyWindow() -> UIWindow?
{
    var keyWindow : UIWindow?
    if #available(iOS 13.0, *) {
        guard let scene = UIApplication.shared.connectedScenes.first else { return nil }
        guard let winScene = scene as? UIWindowScene else { return nil }
        keyWindow = UIWindow.init(windowScene: winScene)
    }
    else {
        keyWindow = UIApplication.shared.keyWindow
    }
    return keyWindow
}

// MARK: - 获取时间戳（秒级）
/// 获取时间戳（秒级，注意小数）
/// - Returns: 时间戳
public func x_getTimeStamp() -> TimeInterval
{
    let ts = Date().timeIntervalSince1970
    // xLog(ts)
    return ts
}

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
        spaceName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
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
    let ret = h / 375.0 * x_width
    return ret
}
/// 根据设计宽度计算实际宽度
/// - Parameter w: 设计宽度
/// - Returns: 实际宽度
public func x_getRealWidth(withDesignWidth w : CGFloat) -> CGFloat
{
    let ret = w / 375.0 * x_width
    return ret
}
