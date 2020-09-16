//
//  xRequestMaskViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xRequestMaskViewController: xViewController {
    
    // MARK: - IBOutlet Property
    /// 菊花控件
    @IBOutlet weak var aiView: UIActivityIndicatorView!
    /// gif容器
    @IBOutlet weak var gifIcon: UIImageView!
    /// 动画容器
    @IBOutlet weak var animeContainer: xClearView!
    /// 提示内容
    @IBOutlet weak var msgLbl: UILabel!
    
    // MARK: - Public Property
    /// 配置
    public var config = xRequestMaskConfig()
    
    // MARK: - Private Property
    /// 承载动画的layer
    let animeLayer = CAShapeLayer()
    /// 是否正在显示
    var isShow = false
    
    // MARK: - Public Override Func
    static let shared = xRequestMaskViewController.quickInstancetype()
    public override class func quickInstancetype() -> Self {
        if let vc = xRequestMaskViewController.new(storyboard: "xRequestMask") {
            return vc as! Self
        }
        return xRequestMaskViewController() as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        xRequestMaskViewController.recoverDefaultStyle()
        self.animeLayer.backgroundColor = UIColor.clear.cgColor
        self.animeLayer.fillColor = UIColor.clear.cgColor
        self.animeContainer.layer.addSublayer(self.animeLayer)
    }
    
    // MARK: - Public Func
    /// 恢复默认样式
    public static func recoverDefaultStyle()
    {
        let config = shared.config
        config.bgStyle = .clear
        config.flagStyle = .indicator
    }
    /// 设置随机样式
    public static func setRandomStyle()
    {
        let config = shared.config
        config.bgStyle = arc4random() % 2 == 0 ? .clear : .gray
        config.flagStyle = arc4random() % 2 == 0 ? .indicator : .anime
        let arr : [xRequestMaskConfig.xLoadingAnimeTypeEnum] = [.lineJump, .eatBeans, .magic1, .magic2]
        let idx = arc4random() % 4
        config.animeStyle = arr[Int(idx)]
    }
    /// 显示遮罩
    /// - Parameters:
    ///   - style: 遮罩样式
    ///   - msg: 提示内容
    public static func display(msg : String? = nil,
                               delay : TimeInterval = 30)
    {
        guard shared.isShow == false else { return }    // 保证只显示1个遮罩
        guard let window = x_getKeyWindow() else { return }
        shared.isShow = true
        // 添加UI
        shared.view.alpha = 0
        shared.msgLbl.text = msg
        shared.updateMaskStyle()
        shared.startAnimation()
        window.addSubview(shared.view)
        // 展示UI
        UIView.animate(withDuration: 0.25, animations: {
            shared.view.alpha = 1
        }, completion: {
            (finish) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                self.dismiss()
            })
        })
    }
    /// 隐藏遮罩
    public static func dismiss()
    {
        guard shared.isShow else { return }
        UIView.animate(withDuration: 0.25, animations: {
            shared.view.alpha = 0
        }, completion: {
            (finish) in
            shared.isShow = false
            shared.stopAnimation()
            shared.view.removeFromSuperview()
        })
    }
    /// 更新遮罩提示
    public static func updateMessage(_ msg : String)
    {
        shared.msgLbl.text = msg
    }
    
    // MARK: - Private Func
    /// 更新遮罩样式
    private func updateMaskStyle()
    {
        // 背景样式
        let config = self.config
        switch config.bgStyle {
        case .clear:
            self.view.backgroundColor = .clear
        case .gray:
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        // 加载控件样式
        switch config.flagStyle {
        case .indicator:
            self.gifIcon.isHidden = true
            self.aiView.isHidden = false
        case .gif:
            self.gifIcon.isHidden = false
            self.aiView.isHidden = true
        case .anime:
            self.gifIcon.isHidden = true
            self.aiView.isHidden = true
        }
    }
    /// 开始动画
    private func startAnimation()
    {
        let config = self.config
        switch config.flagStyle {
        case .indicator:    // 系统菊花
            self.aiView.startAnimating()
        case .gif:          // 自定义gif
            self.gifIcon.startAnimating()
        case .anime:        // CA动画
            // 清空旧动画
            self.stopAnimation()
            // 添加新动画
            switch config.animeStyle {
            case .lineJump: // 线条跳动
                self.addLineJumpAnime()
            case .eatBeans: // 吃豆人
                self.addEatBeansAnime()
            case .magic1, .magic2:  // 六芒星
                self.addMagicAnime()
            }
        }
    }
    /// 结束动画
    private func stopAnimation()
    {
        let config = self.config
        switch config.flagStyle {
        case .indicator:
            self.aiView.stopAnimating()
        case .gif:
            self.gifIcon.stopAnimating()
        case .anime:
            for layer in self.animeLayer.sublayers ?? [] {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
}
