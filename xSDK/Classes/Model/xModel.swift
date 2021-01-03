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
    private var ivarList = [String]()
    
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
    public func copyIvarData(from model : xModel?,
                             isCopyEmpty : Bool = false)
    {
        guard let obj = model else { return }
        // 要拼接内容的对象必须于self同级或是self父级，key才能都找得到对应的value
        guard self.isKind(of: obj.classForCoder) else {
            xWarning("两个对象不是同源，无法拼接 : \(self.classForCoder) ≠ \(obj.classForCoder)")
            return
        }
        let ivarList = obj.getIvarList(obj: obj)
        for key in ivarList {
            let value = obj.value(forKey: key)
            // 如果不执行替换空数据操作，则跳过
            if isCopyEmpty == false, value == nil {
                continue
            }
            self.setValue(value, forKey: key)
        }
    }
    
    // TODO:  数据转换
    /// 转换成成员属性字典
    /// - Returns: 生成的字典
    public func toDictionary() -> [String : Any]
    {
        let dict = self.getDictionary(obj: self)
        return dict
    }
    /// 转换成成员属性字典(字符串成员)
    /// - Returns: 生成的字典
    public func toStringDictionary() -> [String : String]
    {
        let dict = self.getStringDictionary(obj: self)
        return dict
    }
    
    // MARK: - Private Func
    // TODO: 获取成员属性列表
    /// 获取一个对象的成员属性列表
    /// - Parameter obj: 指定的对象
    /// - Returns: 成员属性列表
    private func getIvarList(obj : xModel) -> [String]
    {
        // 如果有缓存则直接返回
        guard self.ivarList.count == 0 else { return self.ivarList }
        var ret : [String] = []
        if self.isMember(of: NSObject.classForCoder()) { return ret }
        if self.isMember(of: xModel.classForCoder()) { return ret }
        // 读取对象父类的成员变量
        guard var spClass = obj.superclass else { return ret }
        while spClass != NSObject.classForCoder() {
            let spIvarList = self.getIvarList(objClass: spClass)
            ret += spIvarList
            if let sspClass = spClass.superclass() {
                // 父级的父级
                spClass = sspClass
            }
            else {
               break
            }
        }
        // 读取对象自身的成员变量
        ret += self.getIvarList(objClass: obj.classForCoder)
        /* 映射
         let morror = Mirror.init(reflecting: obj)
         for (key, value) in (morror.children) {
         if key == nil {
         continue
         }
         result[key!] = value
         }
         */
        // 排个序
        ret.sort()
        self.ivarList = ret
        return ret
    }
    /// 获取指定类的成员属性列表
    /// - Parameter objClass: 指定的类
    /// - Returns: 成员属性列表
    private func getIvarList(objClass : AnyClass) -> [String]
    {
        var ret : [String] = []
        var count : UInt32 = 0
        let list = class_copyIvarList(objClass, &count)
        for i in 0 ..< count {
            let ivar = list![Int(i)]
            let ivarName = ivar_getName(ivar)
            let nName = String(cString: ivarName!)
            ret.append(nName)
        }
        free(list)
        return ret
    }
    
    // TODO: 获取成员属性键值表
    /// 获取一个对象的成员属性键值表
    /// - Parameter obj: 指定的对象
    /// - Returns: 成员属性键值表
    private func getDictionary(obj : xModel) -> [String : Any]
    {
        var result = [String : Any]()
        let ivarList = self.getIvarList(obj: obj)
        for key in ivarList {
            // 过滤本地创建的数据
            guard key != "xid" else { continue }
            guard key != "xContent" else { continue }
            guard key != "xOrigin" else { continue }
            guard let value = self.value(forKey: key) else { continue }
            let property = value as AnyObject
            // 递归继续拆分
            if let subObj = property as? xModel {
                let subResult = self.getDictionary(obj: subObj)
                result.updateValue(subResult, forKey: key)
            }
            else {
                result.updateValue(value, forKey: key)
            }
        }
        return result
    }
    /// 获取一个对象的成员属性键值表(只返回字符串成员，方便存取)
    /// - Parameter obj: 指定的对象
    /// - Returns: 成员属性键值表
    private func getStringDictionary(obj : xModel) -> [String : String]
    {
        var result = [String : String]()
        let ivarList = self.getIvarList(obj: obj)
        for key in ivarList {
            // 过滤本地创建的数据
            guard key != "xid" else { continue }
            guard key != "xContent" else { continue }
            guard key != "xOrigin" else { continue }
            guard let value = self.value(forKey: key) else { continue }
            guard let str = value as? String else { continue }
            result[key] = str
        }
        return result
    }
    
}
