//
//  xGlobalLog.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

// MARK: - 自定义控制台打印方法
/// 自定义控制台打印方法
public func x_log(_ items: Any...,
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
public func x_warning(_ items: Any...,
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