//
//  xLineView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xLineView: UIView {
    
    // MARK: - Public Property
    /// 线条颜色
    @IBInspectable public var lineColor : UIColor = .groupTableViewBackground
    
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
        self.backgroundColor = self.lineColor
        self.isUserInteractionEnabled = false
    }
}
