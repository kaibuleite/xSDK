//
//  xPage.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

class xPage: NSObject {
    
    // MARK: - Public Property
    /// 当前页数
    var current : Int = 1
    /// 总页数(默认1页,从服务器返回具体数据)
    var total : Int = 1
    /// 每页数据数量(默认20,根据情况自己修改)
    var size : Int = 20
    /// 是否还有数据(默认否,根据当前页自动判断)
    var isMore : Bool {
        if self.current >= self.total {
            self.current = self.total
            return false
        }
        else {
            return true
        }
    }
}
