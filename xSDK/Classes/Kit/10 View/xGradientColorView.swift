//
//  xGradientColorView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xGradientColorView: UIView {
    
    // MARK: - Private Property
    /// 顶部渐变填充色Layer
    private var colorLayer = CAGradientLayer()
    
    // MARK: - 视图加载
    override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorLayer.frame = self.bounds
    }
    
    // MARK: - 内部调用
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
    }
    
    // MARK: - 方法调用
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
