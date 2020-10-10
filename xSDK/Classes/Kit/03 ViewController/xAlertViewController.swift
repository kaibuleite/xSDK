//
//  xAlertViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

open class xAlertViewController: xViewController {

    // MARK: - Enum
    /// 弹窗显示动画样式
    public enum xAlertDisplayAnimeTypeEnum {
        /// 淡化
        case fade
        /// 缩放
        case scale
        /// 随机
        case random
    }
    
    // MARK: - IBOutlet Property
    /// 弹窗容器
    @IBOutlet weak var alertContainer: UIView!
    
    // MARK: - Open Override Func
    open override class func quickInstancetype() -> Self {
        let vc = xAlertViewController()
        return vc as! Self
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    // MARK: - Public Func
    /// 显示选择器
    /// - Parameters:
    ///   - animeType: 动画类型
    ///   - isSpring: 是否开启弹性动画
    public func display(animeType : xAlertDisplayAnimeTypeEnum = .random,
                        isSpring : Bool = true)
    {
        // 保存数据
        self.view.isHidden = false
        switch animeType {
        case .fade:
            self.alertContainer.alpha = 0
            self.alertContainer.transform = .identity
            UIView.animate(withDuration: 0.25, animations: {
                self.alertContainer.alpha = 1
            })
        case .scale:
            self.alertContainer.alpha = 1
            self.alertContainer.transform = .init(scaleX: 0, y: 0)
            if isSpring {
                let damping = CGFloat(0.7)  // 弹性阻尼，越小效果越明显
                let velocity = CGFloat(10) // 弹性修正速度，越大修正越快
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: {
                    self.alertContainer.transform = .identity
                })
            }
            else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertContainer.transform = .identity
                })
            }
        case .random:   // 随机递归
            let type = self.getRandmAnimeType()
            self.display(animeType: type, isSpring: isSpring)
        }
    }
    
    /// 隐藏选择器
    /// - Parameters:
    ///   - animeType: 动画类型
    public func dismiss(animeType : xAlertDisplayAnimeTypeEnum = .random)
    {
        switch animeType {
        case .fade:
            UIView.animate(withDuration: 0.25, animations: {
                self.alertContainer.alpha = 0
            }, completion: {
                (finish) in
                self.view.isHidden = true
            })
        case .scale:
            UIView.animate(withDuration: 0.25, animations: {
                self.alertContainer.transform = .init(scaleX: 0, y: 0)
            }, completion: {
                (finish) in
                self.view.isHidden = true
            })
        case .random:   // 随机递归
            let type = self.getRandmAnimeType()
            self.dismiss(animeType: type)
        }
    }

    // MARK: - Private Func
    /// 获取随机动画类型
    private func getRandmAnimeType() -> xAlertDisplayAnimeTypeEnum
    {
        var arr = [xAlertDisplayAnimeTypeEnum]()
        arr = [.fade, .scale]
        let idx = arc4random() % UInt32(arr.count)
        let ret = arr[Int(idx)]
        return ret
    }
}
