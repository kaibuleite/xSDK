//
//  xView.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

open class xView: UIView {

    // MARK: - Private Property
    /// 是否初始化样式
    private var isLoadViewStyle = false
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.loadViewStyle()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // 如果没有实现awakeFromNib，则会调用该方法
        self.loadViewStyle()  
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewStyle()
    }

    // MARK: - Open Func
    /// 初始化控件
    open func initKit() { }
    /// 添加其他控件
    open func addKit() { }
    
    // MARK: - Private Func
    /// 加载视图样式
    private func loadViewStyle()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isLoadViewStyle == false else { return }
        
        self.backgroundColor = .clear
        DispatchQueue.main.async {
            self.initKit()
            self.addKit()
        }
        
        self.isLoadViewStyle = true
        objc_sync_exit(self)
    }
}
