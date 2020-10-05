//
//  xImageView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xImageView: UIImageView {
    
    // MARK: - IBInspectable Property
    /// 是否为圆形图片
    @IBInspectable public var isCircle : Bool = false {
        didSet {
            guard self.isCircle else { return }
            self.layer.cornerRadius = self.bounds.size.width / 2.0
        }
    }
    @IBInspectable public var defaultFillColor : UIColor = .clear
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Override Func
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill // 全填充
        let size = self.bounds.size
        if self.defaultFillColor == .clear {
            self.image = UIColor.xNewRandom(alpha: 0.3).xToImage(size: size)
        }
        else {
            self.image = self.defaultFillColor.xToImage(size: size)
        }
        // self.backgroundColor = UIColor.newRandom(alpha: 0.3)
        guard self.isCircle else { return }
        self.layer.cornerRadius = self.bounds.size.width / 2.0
    }
}
