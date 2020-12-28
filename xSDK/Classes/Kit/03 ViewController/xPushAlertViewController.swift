//
//  xPushAlertViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

open class xPushAlertViewController: xViewController {
    
    // MARK: - IBOutlet Property
    /// 弹窗容器
    @IBOutlet public weak  var alertContainer: UIView!
    /// 弹窗容器底部距离
    @IBOutlet public weak var alertContinerBottomLayout: NSLayoutConstraint!
    
    // MARK: - Open Property
    open var isOpenTapBgClose : Bool {
        return true
    }
    
    // MARK: - Open Override Func
    open override class func quickInstancetype() -> Self {
        let vc = xPushAlertViewController()
        return vc as! Self
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // 手势点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapBackground(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBOutlet Func
    /// 背景关闭
    @IBAction func closeBtnClick()
    {
        self.dismiss()
    }
    
    // MARK: - Public Func
    /// 显示选择器
    /// - Parameters:
    ///   - animeType: 动画类型
    ///   - isSpring: 是否开启弹性动画
    public func display(isSpring : Bool = true)
    {
        self.alertContinerBottomLayout.constant = xScreenHeight
        self.view.layoutIfNeeded()
        self.view.isHidden = false
        if isSpring {
            let damping = CGFloat(0.75)  // 弹性阻尼,越小效果越明显
            let velocity = CGFloat(0) // 弹性初始速度,越大一开始变动越快
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: {
                self.alertContinerBottomLayout.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alertContinerBottomLayout.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    /// 隐藏选择器
    /// - Parameters:
    ///   - animeType: 动画类型
    public func dismiss()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertContinerBottomLayout.constant = xScreenHeight
            self.view.layoutIfNeeded()
            
        }, completion: {
            (finish) in
            self.view.isHidden = true
        })
    }
    
    // MARK: - Private Func
    /// 点击背景
    @objc private func tapBackground(_ gesture : UITapGestureRecognizer)
    {
        if self.isOpenTapBgClose {
            self.dismiss()
        }
    }
}
