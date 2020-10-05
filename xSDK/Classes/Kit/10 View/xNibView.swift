//
//  xNibView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xNibView: xView {
    
    // MARK: - IBOutlet Property
    /// 内容容器
    @IBOutlet var nibView: UIView!
    /// 绑定的视图控制器
    @IBOutlet public weak var vc: UIViewController?
    
    // MARK: - Private Property
    /// 是否初始化样式
    private var isLoadNibStyle = false
    
    // MARK: - 内存释放
    deinit {
        self.vc = nil
    }
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.loadNibStyle()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // 如果没有实现awakeFromNib，则会调用该方法
        self.loadNibStyle()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xWarning("该类型视图必须搭配nib初始化")
        // self.loadNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
    }
    
    // MARK: - Private Func
    /// 加载nib样式
    private func loadNibStyle()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isLoadNibStyle == false else { return }
        
        // 加载xib
        let bundle = Bundle.init(for: self.classForCoder)
        bundle.loadNibNamed(self.xClassStruct.name, owner: self, options: nil)
        // 添加view
        self.nibView.backgroundColor = .clear
        self.nibView.clipsToBounds = false
        self.addSubview(self.nibView)
        self.sendSubviewToBack(self.nibView)
        
        self.isLoadNibStyle = true
        objc_sync_exit(self)
    }
}
