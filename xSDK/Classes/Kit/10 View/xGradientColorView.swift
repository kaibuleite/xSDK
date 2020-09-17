//
//  xGradientColorView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xGradientColorView: xView {
    
    // MARK: - Private Property
    /// 顶部渐变填充色Layer
    private var colorLayer = CAGradientLayer()
    
    // MARK: - Public Override Func
    public override func initKit() {
        self.backgroundColor = .clear
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.colorLayer.frame = self.bounds
    }
    
    // MARK: - Public Func
    /// 设置填充色
    public func setGradient(colors : [UIColor],
                            startPoint : CGPoint = .init(x: 0.5, y: 0),
                            endPoint : CGPoint = .init(x: 0.5, y: 1))
    {
        self.backgroundColor = .clear
        self.colorLayer.removeFromSuperlayer()
        
        var cgcolors = [CGColor]()
        for color in colors {
            cgcolors.append(color.cgColor)
        }
        self.colorLayer.frame = self.bounds
        self.colorLayer.colors = cgcolors
        self.colorLayer.startPoint = startPoint
        self.colorLayer.endPoint = endPoint
        
        self.layer.insertSublayer(self.colorLayer, at: 0)
    }
    
}
