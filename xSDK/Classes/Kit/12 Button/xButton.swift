//
//  xButton.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

class xButton: UIButton {
    
    // MARK: - Public Property
    /// 圆角
    @IBInspectable public var cornerRadius : CGFloat = 0
    
    // MARK: - 视图加载
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.cornerRadius
    }
}
