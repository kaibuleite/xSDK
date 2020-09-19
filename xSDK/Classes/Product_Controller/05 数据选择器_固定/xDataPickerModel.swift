//
//  xDataPickerModel.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xDataPickerModel: NSObject {
    
    // MARK: - Public Property
    /// 数据id
    public var id = ""
    /// 数据名称
    public var name = ""
    /// 附带信息
    public var info : Any?
    
    // MARK: - Public Func
    /// 实例化变量
    public init(id : String = "",
                name : String,
                info : Any? = nil)
    {
        self.id = id
        self.name = name
        self.info = info
    }
    public override init() {
        
    }
    
    /// 创建数据列表
    public static func newList(array : [String]) -> [xDataPickerModel]
    {
        var ret = [xDataPickerModel]()
        array.forEach {
            (name) in
            let model = xDataPickerModel.init(name: name)
            ret.append(model)
        }
        return ret
    }
    /// 创建数据列表
    public static func newList(count : Int,
                               prefix : String) -> [xDataPickerModel]
    {
        var ret = [xDataPickerModel]()
        for i in 0 ..< count {
            let name = prefix + "\(i)"
            let model = xDataPickerModel.init(name: name)
            ret.append(model)
        }
        return ret
    }
}
