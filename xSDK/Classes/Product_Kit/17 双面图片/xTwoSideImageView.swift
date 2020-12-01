//
//  xTwoSideImageView.swift
//  xSDK
//
//  Created by Mac on 2020/12/1.
//

import UIKit

public class xTwoSideImageView: xView {

    // MARK: - Enum
    /// 面向枚举
    public enum SideEnum {
        /// 正面
        case top
        /// 背面
        case back
    }
    
    // MARK: - Public Property
    /// 当前朝向
    public var currentSide = SideEnum.top
    
    // MARK: - Private Property
    /// 正面图
    let topIcon = UIImageView.init()
    /// 背面图
    let backIcon = UIImageView.init()
    /// 是否正在翻转中
    var isFlipping = false
    
    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubview(self.topIcon)
        self.addSubview(self.backIcon)
    }
    public override func viewDidAppear() {
        super.viewDidAppear()
        let frame = self.bounds
        self.topIcon.frame = frame
        self.backIcon.frame = frame
    }
    
    // MARK: - Public Func
    /// 设置图片
    /// - Parameters:
    ///   - topImage: 正面图片
    ///   - backImage: 反面图片
    ///   - side: 朝向
    public func set(topImage : UIImage?,
                    backImage : UIImage?,
                    side : SideEnum)
    {
        self.topIcon.image = topImage
        self.backIcon.image = backImage
        switch side {
        case .top:
            self.topIcon.isHidden = false
            self.backIcon.isHidden = true
        case .back:
            self.topIcon.isHidden = true
            self.backIcon.isHidden = false
        }
    }
    /// 设置图片
    /// - Parameters:
    ///   - topImageUrl: 正面图片链接
    ///   - topPlaceholderImage: 正面占位图
    ///   - backImageUrl: 反面图片链接
    ///   - backPlaceholderImage: 背面占位图
    ///   - side: 朝向
    public func set(topImageUrl : String,
                    topPlaceholderImage : UIImage? = xAppManager.shared.placeholderImage,
                    backImageUrl : String,
                    backPlaceholderImage : UIImage? = xAppManager.shared.placeholderImage,
                    side : SideEnum)
    {
        self.topIcon.xSetWebImage(url: topImageUrl, placeholderImage: topPlaceholderImage)
        self.backIcon.xSetWebImage(url: backImageUrl, placeholderImage: backPlaceholderImage)
        switch side {
        case .top:
            self.topIcon.isHidden = false
            self.backIcon.isHidden = true
        case .back:
            self.topIcon.isHidden = true
            self.backIcon.isHidden = false
        }
    }
    
    /// 翻转图片
    /// - Parameters:
    ///   - duration: 动画时长
    public func flip(duration : TimeInterval = 0.5)
    {
        switch self.currentSide {
        case .top:  self.flip(to: .back, duration: duration)
        case .back: self.flip(to: .top, duration: duration)
        }
    }
    
    /// 翻转图片
    /// - Parameters:
    ///   - side: 朝向
    ///   - duration: 动画时长
    public func flip(to side : SideEnum,
                     duration : TimeInterval = 0.5)
    {
        guard self.isFlipping == false else { return }
        guard self.currentSide != side else { return }
        
        self.isFlipping = true
        self.currentSide = side
        
        UIView.animate(withDuration: duration) {
            self.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 1, 0)
        } completion: {
            (finish) in
            switch side {
            case .top:
                self.topIcon.isHidden = false
                self.backIcon.isHidden = true
            case .back:
                self.topIcon.isHidden = true
                self.backIcon.isHidden = false
            }
            UIView.animate(withDuration: duration) {
                self.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            } completion: {
                (finish) in
                self.isFlipping = false
            }
        }
    }
    
    // MARK: - Private Func
}
