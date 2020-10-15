//
//  xNoticeScrollView.swift
//  Alamofire
//
//  Created by Mac on 2020/10/15.
//

import UIKit

public class xNoticeScrollView: xContainerView {

    // MARK: - Enum
    /// 公告滚动方向
    public enum xScrollNoticeDirectionEnum {
        /// 垂直
        case vertical
        /// 水平
        case horizontal
    }
    
    // MARK: - Handle
    /// 选择公告回调
    public typealias xHandlerChooseNotice = (String) -> Void
    /// 刷新数据回调
    public typealias xHandlerReloadCompleted = () -> Void
    
    // MARK: - Public Property
    /// 滚动方向
    public var scrollDirection = xScrollNoticeDirectionEnum.vertical
    /// 字体大小(默认15)
    public var textFontSize = CGFloat(15)
    /// 停留时间
    public var stopDuration = Double(3)
    
    // MARK: - Private Property
    /// 当前滚动的idx
    private var currentNoticeIndex = 0
    /// 是否中断动画
    private var isStopAnimation = false
    /// 子控件
    private var itemViewArray = [UIButton]()
    /// 选择回调
    private var chooseHandler : xHandlerChooseNotice?
    /// 刷新回调
    private var reloadHandler : xHandlerReloadCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.reloadHandler = nil
        self.clearOldNoticeItem()
        xLog("📢 xNoticeScrollView")
    }
    
    // MARK: - Public Override Func
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.itemViewArray.count > 0 else { return }
        // 更新UI
        let frame = self.bounds
        for item in self.itemViewArray {
            // 计算宽度
            item.frame = frame
            item.isHidden = true
        }
        self.reloadHandler?()
        // 只有1个公告不需要执行动画
        guard self.itemViewArray.count > 1 else {
            self.itemViewArray.first?.isHidden = false
            return
        }
        self.startAnimation()
    }
    
    // MARK: - Public Func
    public func reload(dataArray : [String],
                       completed handler1 : @escaping xHandlerReloadCompleted,
                       choose handler2 : @escaping xHandlerChooseNotice)
    {
        self.clipsToBounds = true
        guard dataArray.count > 0 else {
            xWarning("木有数据")
            return
        }
        self.clearOldNoticeItem()
        self.currentNoticeIndex = 0
        self.reloadHandler = handler1
        self.chooseHandler = handler2
        
        // 添加规格控件
        let font = UIFont.systemFont(ofSize: self.textFontSize)
        for (i, title) in dataArray.enumerated()
        {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.contentHorizontalAlignment = .left
            // 添加响应事件
            btn.xAddClick {
                [unowned self] (sender) in
                guard let title = sender.currentTitle else { return }
                self.chooseHandler?(title)
            }
            self.addSubview(btn)
            self.itemViewArray.append(btn)
        }
        self.layoutIfNeeded()
    }
    /// 开始动画
    public func startAnimation()
    {
        self.isStopAnimation = false
        self.startAnimation(at: 0)
    }
    /// 暂停动画
    public func stopAnimation()
    {
        self.isStopAnimation = true
    }
    
    // MARK: - Private Func
    /// 清空旧消息公告控件
    private func clearOldNoticeItem()
    {
        for item in self.itemViewArray {
            item.xRemoveClickHandler()
            item.removeFromSuperview()
        }
        self.itemViewArray.removeAll()
    }
    /// 滚动动画
    private func startAnimation(at idx : Int)
    {
        // 条件判断（防止突发情况多次调用）
        guard self.isStopAnimation == false else { return }
        // 获取公告控件
        guard self.itemViewArray.count > 1 else { return }
        var i = idx
        if idx < 0 { i = self.itemViewArray.count - 1 }
        if idx >= self.itemViewArray.count { i = 0 }
        let item = self.itemViewArray[i]
        // 根据滚动方向设置动画
        var frame1 = item.frame
        var frame2 = item.frame
        var frame3 = item.frame
        switch self.scrollDirection {
        case .horizontal:
            frame1.origin.x = self.bounds.width
            frame2.origin.x = 0
            frame3.origin.x = -frame.width
        case .vertical:
            frame1.origin.y = self.bounds.height
            frame2.origin.y = 0
            frame3.origin.y = -frame.height
        }
        // 初始位置
        item.frame = frame1
        item.isHidden = false
        UIView.animate(withDuration: 0.25) {
            // 移动到显示位置
            item.frame = frame2
        } completion: {
            [weak self] (finish) in
            guard let ws = self else { return }
            // 停留
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ws.stopDuration, execute: {
                // 离开，显示下一条公告
                UIView.animate(withDuration: 0.25) {
                    item.frame = frame3
                } completion: {
                    [weak self] (finish) in
                    item.isHidden = true
                    guard let ws = self else { return }
                    ws.startAnimation(at: item.tag + 1)
                }
            })
        }
    }
}

