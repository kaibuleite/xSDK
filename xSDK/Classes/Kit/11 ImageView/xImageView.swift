//
//  xImageView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xImageView: UIImageView {
    
    // MARK: - Public Property
    /// 是否为圆形图片
    @IBInspectable var isCircle : Bool = false {
        didSet {
            guard self.isCircle else { return }
            self.layer.cornerRadius = self.bounds.size.width / 2.0
        }
    }
    
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
    
    // MARK: - 内部调用
    /// 设置内容UI
    private func setContentKit()
    {
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill // 全填充
        let size = self.bounds.size
        self.image = UIColor.x_random(alpha: 0.3).x_toImage(size: size)
        // self.backgroundColor = UIColor.newRandom(alpha: 0.3)
        guard self.isCircle else { return }
        self.layer.cornerRadius = self.bounds.size.width / 2.0
    }
}
