//
//  xContainerView.swift
//  xSDK
//
//  Created by Mac on 2020/9/16.
//

import UIKit

public class xContainerView: xView {
    
    // MARK: - IBInspectable Property
    /// 填充色
    @IBInspectable public var fillColor : UIColor = .clear {
        didSet {
            self.backgroundColor = self.fillColor
        }
    }
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundColor = self.fillColor
    }
}
