//
//  xNibView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xNibView: UIView {
    
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
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
    }
    
    // MARK: - Public Override Func
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }
    
    // MARK: - Open Func
    /// 设置通用数据，不要使用xib控件
    open func addKit() { }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
        guard let name = x_getClassName(withObject: self) else { return }
        // 加载xib
        let bundle = Bundle.init(for: self.classForCoder)
        bundle.loadNibNamed(name, owner: nil, options: nil) 
        // 添加view
        self.nibView.backgroundColor = .clear
        self.addSubview(self.nibView)
        DispatchQueue.main.async {
            // 改变布局层次
            self.sendSubviewToBack(self.nibView)
            self.addKit()
        }
    }
    
}
