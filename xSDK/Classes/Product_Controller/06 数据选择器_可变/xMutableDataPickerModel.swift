//
//  xMutableDataPickerModel.swift
//  Alamofire
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xMutableDataPickerModel: NSObject {
    
    // MARK: - Public Property
    /// 数据id
    public var id = ""
    /// 数据名称
    public var name = ""
    /// 附带信息
    public var info : Any?
    /// 子级
    public var childList = [xMutableDataPickerModel]() {
        didSet {
            for (i, model) in self.childList.enumerated() {
                model.parent = self
                model.row = i
                model.column = self.column + 1
            }
        }
    }
    
    // MARK: - Private Property
    /// 父级
    weak var parent : xMutableDataPickerModel?
    /// 行
    var row = 0
    /// 列
    var column = 0
    /// 行编号
    var rowNumber : String {
        if let parent = self.parent {
            return parent.rowNumber + "\(self.row)"
        }
        return "\(self.row)"
    }
    
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
    public static func newList(array : [String]) -> [xMutableDataPickerModel]
    {
        var ret = [xMutableDataPickerModel]()
        array.forEach {
            (name) in
            let model = xMutableDataPickerModel.init(name: name)
            ret.append(model)
        }
        return ret
    }
    /// 创建数据列表
    public static func newList(count : Int,
                               prefix : String) -> [xMutableDataPickerModel]
    {
        var ret = [xMutableDataPickerModel]()
        for i in 0 ..< count {
            let name = prefix + "\(i)"
            let model = xMutableDataPickerModel.init(name: name)
            ret.append(model)
        }
        return ret
    }
}
