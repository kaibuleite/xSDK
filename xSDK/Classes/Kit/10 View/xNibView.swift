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
    
    // MARK: - 内存释放
    deinit {
        self.vc = nil
    }
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.loadNib()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // self.loadNib() // awakeFromNib会调用，不需要重复初始化
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        x_warning("该类型视图必须搭配nib初始化")
        // self.loadNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
    }
    
    // MARK: - Private Func
    /// 加载nib
    private func loadNib()
    {
        guard let name = x_getClassName(withObject: self) else { return }
        // 加载xib
        let bundle = Bundle.init(for: self.classForCoder)
        bundle.loadNibNamed(name, owner: nil, options: nil)
        // 添加view
        self.nibView.backgroundColor = .clear
        self.addSubview(self.nibView)
        self.sendSubviewToBack(self.nibView)
    }
}
