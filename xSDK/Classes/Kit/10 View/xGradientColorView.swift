//
//  xGradientColorView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xGradientColorView: UIView {
    
    // MARK: - Private Property
    /// 顶部渐变填充色Layer
    private var colorLayer = CAGradientLayer()
    
    // MARK: - Public Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.colorLayer.frame = self.bounds
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
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
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
    }
}
