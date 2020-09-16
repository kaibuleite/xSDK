//
//  xClearView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xClearView: UIView {
    
    // MARK: - Public Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        self.backgroundColor = .clear
    }
}
