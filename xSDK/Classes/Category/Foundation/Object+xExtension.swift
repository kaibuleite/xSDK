//
//  Object+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import Foundation

extension NSObject {

    // MARK: - Public Property
    /// 类的结构（命名空间，类名）
    public var xClassStruct : (space : String, name : String)
    {
        let classStr = NSStringFromClass(self.classForCoder)
        // 直接转换类结构，格式为一般为 命名空间.类名
        let arr = classStr.components(separatedBy: ".")
        var spaceName = ""
        var className = ""
        if arr.count == 2 {
            // 直接拆分数组
            spaceName = arr[0]
            className = arr[1]
        }
        else {
            // 从info.plist读取类结构
            let bundle = Bundle.init(for: self.classForCoder)
            if let info = bundle.infoDictionary {
                if let name = info["CFBundleExecutable"] as? String {
                    spaceName = name
                }
            }
            className = classStr
        }
        return (spaceName, className)
    }
}
