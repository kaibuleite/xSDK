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

// MARK: - 获取对象的成员变量名称列表
/// 获取一个对象的成员属性列表
/// - Parameter obj: 指定的对象
/// - Returns: 成员属性列表
public func xGetIvarList(obj : NSObject) -> [String]
{
    var ret = [String]()
    if obj.isMember(of: NSObject.classForCoder()) { return ret }
    // 读取对象父类的成员变量
    guard var spClass = obj.superclass else { return ret }
    while spClass != NSObject.classForCoder() {
        let spIvarList = xGetIvarList(objClass: spClass)
        ret += spIvarList
        // 父级的父级
        guard let sspClass = spClass.superclass() else { break }
        spClass = sspClass
    }
    // 读取对象自身的成员变量
    ret += xGetIvarList(objClass: obj.classForCoder)
    // 排个序
    ret.sort()
    return ret
}

/// 获取指定类的成员属性列表
/// - Parameter objClass: 指定的类
/// - Returns: 成员属性列表
public func xGetIvarList(objClass : AnyClass) -> [String]
{
    var ret = [String]()
    var count = UInt32(0)
    let list = class_copyIvarList(objClass, &count)
    for i in 0 ..< count {
        guard let ivar = list?[Int(i)] else { continue }
        let name = ivar_getName(ivar)
        let str = String(cString: name!)
        ret.append(str)
    }
    free(list)
    return ret
}
