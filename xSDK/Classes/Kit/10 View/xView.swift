//
//  xView.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

open class xView: UIView {

    // MARK: - Private Property
    /// 是否加载过样式
    private var isInitCompleted = false
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initCompleted()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // 如果没有实现awakeFromNib，则会调用该方法
        self.initCompleted()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCompleted()
    }

    // MARK: - Open Func
    /// 视图已加载
    open func viewDidLoad() { }
    /// 视图已显示（GCD调用）
    open func viewDidAppear() { }
    
    // MARK: - Private Func
    /// 初始化完成
    private func initCompleted()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isInitCompleted == false else { return }
        
        self.viewDidLoad()
        DispatchQueue.main.async {
            self.viewDidAppear()
        }
        
        self.isInitCompleted = true
        objc_sync_exit(self)
    }
}
