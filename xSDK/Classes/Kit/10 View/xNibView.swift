//
//  xNibView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xNibView: UIView {
    
    // MARK: - 关联变量
    /// 内容容器
    @IBOutlet var nibView: UIView!
    /// 绑定的视图控制器
    @IBOutlet public weak var vc: UIViewController?
    
    // MARK: - 内存释放
    deinit {
        self.vc = nil
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
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
    }
    
    // MARK: - 内部调用
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
        guard let name = x_getClassName(withObject: self) else { return }
        // 加载xib
        let bundle = Bundle.init(for: self.classForCoder)
        bundle.loadNibNamed(name, owner: nil, options: nil) 
        // 添加view
        self.addSubview(self.nibView)
        // 改变布局层次
        self.sendSubviewToBack(self.nibView)
        DispatchQueue.main.async {
            self.initKit()
        }
    }
    
    // MARK: - 方法重写
    /// 设置通用数据，不要使用xib控件
    open func initKit() { }
}
