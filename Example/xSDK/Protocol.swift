//
//  Protocol.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - 协议的用法
/*
 协议适合用在个别几个拥有独特共同属性的对象，比如这里的土豆和大米不适合榨汁，但是苹果和番茄可以
 */
class Plant : NSObject {
    open var name : String { return "植物名称" }
}
class potato: Plant {
    override var name: String { return "土豆" }
}
class Rice: Plant {
    override var name: String { return "大米" }
}
class Apple: Plant {
    override var name: String { return "苹果" }
}
class Tomato: Plant, JuicingProtocol {
    override var name: String { return "番茄" }
    var juiceName: String = "番茄汁"
    var juiceYield: Double = 0.15
    func juicing(kg: Double) -> Double {
        return kg * juiceYield
    }
}

// MARK: - 榨汁协议
protocol JuicingProtocol {
    /// 榨汁后的名称（果汁名）
    var juiceName : String { get }
    /// 出汁率
    var juiceYield : Double { get }
    
    /// 榨汁操作（mutating 标识必须实现）
    /// - Parameter kg: 原料重量
    func juicing(kg : Double) -> Double
    /*
     协议内的方法如果涉及到会修改自身的，func 要加上 mutating 前缀
     mutating 适合使用在 Struct 、 Enum 之类的数据类型，不适合对象
     */
}

// MARK: - 可以用扩展添加协议
extension Apple: JuicingProtocol {
    var juiceName: String {
        return "苹果汁"
    }
    var juiceYield: Double {
        return 0.4
    }
    func juicing(kg: Double) -> Double {
        return kg * juiceYield
    }
}
