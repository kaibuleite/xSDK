//
//  xGlobalFunction.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

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

// MARK: - 随机返回某个区间范围内的值
/// 随机返回某个区间范围内的值
public func xRandomBetween(min : CGFloat,
                           max : CGFloat) -> CGFloat
{
    // 先取得他们之间的差值
    let sub = abs(max - min) + 1
    // 在差值间随机
    let mode = fmod(Double(arc4random()), Double(sub))
    //将随机的值加到较小的值上
    let ret = min + CGFloat(mode)
    return ret
}
