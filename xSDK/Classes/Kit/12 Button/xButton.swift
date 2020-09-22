//
//  xButton.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

open class xButton: UIButton {
    
    // MARK: - IBInspectable Property
    /// 圆角
    @IBInspectable public var cornerRadius : CGFloat = 0
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.cornerRadius
    }
}
