//
//  xDynamicLineLayer.swift
//  xSDK
//
//  Created by Mac on 2020/12/1.
//

import UIKit

class xDynamicLineLayer: CAShapeLayer {
    
    // MARK: - Public Property
    /// 点1
    var point1 = xDynamicPoint()
    /// 点2
    var point2 = xDynamicPoint()
    
    // MARK: - Public Func
    static func defaulStyleLayer() -> xDynamicLineLayer
    {
        let layer = xDynamicLineLayer.init()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.lineJoin = .round
        layer.lineCap = .round
        layer.lineWidth = 1  // 线宽
        return layer
    }
    
}
