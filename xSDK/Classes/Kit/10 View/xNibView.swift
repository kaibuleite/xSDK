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
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载xib
        let bundle = Bundle.init(for: self.classForCoder)
        bundle.loadNibNamed(self.xClassStruct.name, owner: self, options: nil)
        // 添加view
        self.nibView.backgroundColor = .clear
        self.nibView.clipsToBounds = false
        self.addSubview(self.nibView)
        self.sendSubviewToBack(self.nibView)
        
    }
    open override func viewDidDisappear() {
        super.viewDidDisappear()
        
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
    }
     
}
