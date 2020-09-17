//
//  xView.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

open class xView: UIView {
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // self.setContentKit() // awakeFromNib会调用，不需要重复初始化
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }

    // MARK: - Open Func
    /// 初始化控件
    open func initKit() { }
    /// 添加其他控件
    open func addKit() { }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
        DispatchQueue.main.async {
            self.initKit()
            self.addKit()
        }
    }
}
