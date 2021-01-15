//
//  xModel.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

@objcMembers // 使用kvc必须添加(或者在变量前添加 @objc 标识符)

open class xModel: NSObject {
    
    // MARK: - Public Property
    /// 自定义id
    public var xid = 0
    /// 模拟数据
    public var xContent = "测试内容:\(arc4random() % 10000)"
    /// 原始字典
    public var xOrigin = [String : Any]()
    
    // MARK: - Private Property
    /// 计数器
    private static var xModelCount = 0
    /// 成员变量列表
    private lazy var ivarList : [String] = {
        let ret = xGetIvarList(obj: self)
        return ret
    }()
    
    // MARK: - Open Override Func
    /// 配对成员属性
    open override func setValue(_ value: Any?,
                                forKey key: String)
    {
        guard value != nil else { return }
        // 注意数据类型
        if let obj = value as? String {
            super.setValue(obj, forKey: key)
        }
        // 数字类型转换成字符串
        else
        if let obj = value as? Int {
            super.setValue(String(obj), forKey: key)
        }
        // 数字类型转换成字符串
        else
        if let obj = value as? Float {
            super.setValue(String(obj), forKey: key)
        }
        // 数字类型转换成字符串
        else
        if let obj = value as? Double {
            super.setValue(String(obj), forKey: key)
        }
        // 数组类型
        else
        if let obj = value as? Array<Any> {
            super.setValue(obj, forKey: key)
        }
        // 字典类型
        else
        if let obj = value as? Dictionary<String, Any> {
            super.setValue(obj, forKey: key)
        }
        // xModel
        else
        if let obj = value as? xModel {
            guard let sobj = self.value(forKey: key) as? xModel else { return }
            // xLog(sobj, obj)
            guard sobj.isMember(of: obj.classForCoder) else { return }
            sobj.copyIvarData(from: obj)
        }
        else {
            xWarning("成员变量的数据格式不是常用类型,请确认:\(key) = \(value!), \(type(of: value))")
            super.setValue(value, forKey: key)
        }
    }
    /// 找不到key对应的成员属性
    open override func setValue(_ value: Any?,
                                forUndefinedKey key: String)
    {
        guard xAppManager.shared.isLogModelNoPropertyTip else { return }
        let classname = type(of: self)
        var str = "【\(classname)】找不到成员【\(key)】 = "
        if value != nil {
            str.append("\(value!)")
        }
        else {
            str.append("nil")
        }
        xWarning(str)
    }
    /// 找不到key对应的value
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    // MARK: - Public Override Func
    /// 在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器,子类的子类可以不用管,默认调用子类的构造器
    required public override init() {
        super.init()
        // 通过对象锁保证唯一
        objc_sync_enter(self)
        xModel.xModelCount += 1
        self.xid = xModel.xModelCount
        objc_sync_exit(self)
    }
    
    // MARK: - Public Func
    // TODO: 实例化对象
    /// 实例化对象
    /// - Parameter info: 对象信息字典
    /// - Returns: 对象
    public class func new(dict : [String : Any]?) -> Self?
    {
        guard let info = dict else {
            xWarning("初始化数据为nil")
            return nil
        }
        guard info.keys.count != 0 else {
            xWarning("初始化数据内容为空")
            return nil
        }
        // 获取类的元类型(Meta), 为 AnyClass 格式, 有 type(类型) 和 self(值) 两个参数, 可以以此调用该类下的方法(方法必须实现)
        // let test : MyModel.Type = MyModel.self
        guard let className = self.classForCoder() as? xModel.Type else {
            let classStr = NSStringFromClass(self.classForCoder())
            xWarning("类型[\(classStr)]转换失败，不是继承于xModel")
            return nil
        }
        // 因为在 init() 前加了 required 关键词,保证了 xModel 类必定有 init() 构造方法,可以放心的调用
        let model = className.init()
        model.setValuesForKeys(info)
        // 保存原始字典
        model.xOrigin = info
        return model as? Self
    }
     
    /// 格式化model数组
    /// - Parameters:
    ///   - classType: model类型
    ///   - dataSource: 数据源
    public static func newList(with dataSource : Any?) -> [xModel]
    {
        var ret = [xModel]()
        // 数组嵌字典
        if let infoList = dataSource as? [[String : Any]] {
            for info in infoList {
                if let model = self.new(dict: info) {
                    ret.append(model)
                }
            }
        }
        // 字典嵌字典
        else
        if let infoList = dataSource as? [String : [String : Any]] {
            for (_, info) in infoList {
                if let model = self.new(dict: info) {
                    ret.append(model)
                }
            }
        }
        return ret
    }
    
    /// 创建随机数据列表
    /// - Parameter count: 数据个数
    /// - Returns: 数据列表
    public static func newRandomList(count : Int = 10) -> [xModel]
    {
        var ret = [xModel]()
        for _ in 0 ..< count {
            let model = xModel()
            ret.append(model)
        }
        return ret
    }
    
    // TODO: 从指定对象中拷贝成员变量
    /// 从指定对象中拷贝成员变量
    /// - Parameters:
    ///   - model: 要拼接的对象
    ///   - isCopyEmpty: 是否将空数据也拷进去
    /// - Returns: 拼接后的结果
    public func copyIvarData(from targetModel : xModel?,
                             isCopyEmpty : Bool = false)
    {
        guard let target = targetModel else { return }
        // 要拼接内容的对象必须于self同级或是self父级，key才能都找得到对应的value
        guard self.isKind(of: target.classForCoder) else {
            xWarning("两个对象不是同源，无法拼接 : \(self.classForCoder) ≠ \(target.classForCoder)")
            return
        }
        for key in target.ivarList {
            let value = target.value(forKey: key)
            // 如果不执行替换空数据操作，则跳过
            if isCopyEmpty == false {
                if let obj = value as? String {
                    if obj.isEmpty { continue }
                }
                else
                if let obj = value as? Array<Any> {
                    if obj.isEmpty { continue }
                }
                else
                if let obj = value as? Dictionary<String, Any> {
                    if obj.isEmpty { continue }
                }
            }
            self.setValue(value, forKey: key)
        }
    }
    
    // TODO:  数据转换
    /// 转换成成员属性字典
    /// - Returns: 生成的字典
    public func toDictionary() -> [String : Any]
    {
        var ret = [String : Any]()
        for key in self.ivarList {
            // 过滤本地创建的数据
            guard key != "xid" else { continue }
            guard key != "xContent" else { continue }
            guard key != "xOrigin" else { continue }
            guard let value = self.value(forKey: key) else { continue }
            // 递归继续拆分
            if let subObj = value as? xModel {
                let subRet = subObj.toDictionary()
                ret[key] = subRet
            }
            else {
                ret[key] = value
            }
        }
        return ret
    }
    /// 转换成成员属性字典(字符串成员)
    /// - Returns: 生成的字典
    public func toStringDictionary() -> [String : String]
    {
        var ret = [String : String]()
        for key in self.ivarList {
            // 过滤本地创建的数据
            guard key != "xid" else { continue }
            guard key != "xContent" else { continue }
            guard key != "xOrigin" else { continue }
            guard let value = self.value(forKey: key) else { continue }
            guard let str = value as? String else { continue }
            ret[key] = str
        }
        return ret
    }
    
}
