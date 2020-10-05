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

// MARK: - 显示提示标签
/// 显示提示标签
public func x_alert(message : String,
                    duration : Double = 0) -> Void
{
    guard message.count > 0 else { return }
    // 移除旧控件
    guard let win = xKeyWindow else { return }
    let tag = 124090    // 固定tag
    win.viewWithTag(tag)?.removeFromSuperview()
    // 创建提示标签
    let lbl = UILabel.init()
    lbl.tag = tag
    lbl.numberOfLines = 0
    lbl.preferredMaxLayoutWidth = xScreenWidth - 100
    lbl.text = message
    lbl.textAlignment = NSTextAlignment.center
    lbl.textColor = UIColor.white
    lbl.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
    lbl.layer.masksToBounds = true
    lbl.layer.cornerRadius = 5
    lbl.alpha = 1
    // 修改坐标
    var frame = CGRect.init(origin: CGPoint.zero, size: lbl.xGetContentSize())
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

// MARK: - 自定义控制台打印方法
/// 自定义控制台打印方法
public func xLog(_ items: Any...,
                 showFuncInfo : Bool = false,
                 file: String = #file,
                 line: Int = #line,
                 method: String = #function)
{
    guard xAppManager.shared.isLog else { return }
    if showFuncInfo {
        print("\((file as NSString).lastPathComponent)\t [\(line)]\t \(method)")
    }
    var i = 0
    let j = items.count
    let separator = " "    // 分隔符
    let terminator = "\n"  // 终止符
    for a in items {
        i += 1
        print(a, terminator:i == j ? terminator: separator)
    }
}

// MARK: - 打印警告信息到控制台
/// 打印警告信息到控制台
public func xWarning(_ items: Any...,
                     showFuncInfo : Bool = false,
                     file: String = #file,
                     line: Int = #line,
                     method: String = #function) -> Void
{
    guard xAppManager.shared.isLog else { return }
    if showFuncInfo {
        print("\((file as NSString).lastPathComponent)\t [\(line)]\t \(method)")
    }
    var i = 0
    let j = items.count
    let separator = " "    // 分隔符
    let terminator = "\n"  // 终止符
    for a in items {
        if i == 0 {
            print("⚠️⚠️⚠️⚠️⚠️ ", terminator: separator)
        }
        print(a, terminator: separator)
        i += 1
        if i == j {
            print(" ⚠️⚠️⚠️⚠️⚠️", terminator: terminator)
        }
    }
}
