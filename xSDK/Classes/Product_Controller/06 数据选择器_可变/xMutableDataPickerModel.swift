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
            for model in self.childList {
                model.parent = self
            }
        }
    }
    
    // MARK: - Private Property
    /// 父级
    weak var parent : xMutableDataPickerModel?
    /// 层级
    var layer : Int {
        guard let parent = self.parent else { return 0 }
        return parent.layer + 1
    }
    
    // MARK: - Public Func
    /// 实例化变量
    public init(id : String = "",
                name : String,
                info : Any? = nil)
    {
        self.id = name
        self.name = name
    }
    public override init() {
        
    }
}
