//
//  xCountDownButton.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit

open class xCountDownButton: xButton {
    
    // MARK: - IBInspectable Property
    /// 原标题
    @IBInspectable public var title : String = "获取验证码"
    /// 普通时标题颜色
    @IBInspectable public var titleNormalColor : UIColor = .darkText
    /// 倒计时标题颜色
    @IBInspectable public var titleCountdownColor : UIColor = .lightGray
    
    /// 边框粗细
    @IBInspectable public var borderWidth : CGFloat = 0
    /// 普通时边框颜色
    @IBInspectable public var borderNormalColor : UIColor = .darkText
    /// 倒计时边框颜色
    @IBInspectable public var borderCountdownColor : UIColor = .lightGray
    
    // MARK: - Private Property
    /// 总时长(默认60s)
    private var duration = Int(60)
    /// 定时器
    private var timer : Timer?
    
    // MARK: - 内存释放
    deinit {
        self.closeTimer()
    }
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tag = 0
        self.setTitle(" \(self.title) ", for: .normal)
        self.setTitleColor(titleNormalColor, for: .normal)
        self.layer.borderColor = self.borderNormalColor.cgColor
        self.layer.borderWidth = self.borderWidth
    }
    
    // MARK: - Public Func
    /// 开始倒计时
    /// - Parameters:
    ///   - totalTime: 倒计时时间(默认60s)
    public func startCountDown(duration : Int = 60)
    {
        self.duration = duration
        self.openTimer()
    }
    
    // MARK: - Private Func
    /// 开启定时器
    private func openTimer()
    {
        self.closeTimer()
        self.tag = self.duration
        self.setTitle(" \(self.tag)s ", for: .normal)
        self.setTitleColor(self.titleCountdownColor, for: .normal)
        self.layer.borderColor = self.borderCountdownColor.cgColor
        self.isUserInteractionEnabled = false
        
        let timer = Timer.xNew(timeInterval: 1, repeats: true) {
            [weak self] (timer) in
            guard let ws = self else { return }
            ws.tag -= 1
            ws.setTitle(" \(ws.tag)s ", for: .normal)
            if ws.tag == 0 {
                ws.closeTimer()
                ws.setTitle("\(ws.title) ", for: .normal)
                ws.setTitleColor(ws.titleNormalColor, for: .normal)
                ws.layer.borderColor = ws.borderNormalColor.cgColor
                ws.isUserInteractionEnabled = true
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    /// 关闭定时器
    private func closeTimer()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
}
