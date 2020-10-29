//
//  xSegmentView.swift
//  xSDK
//
//  Created by Mac on 2020/9/21.
//

import UIKit

public class xSegmentView: xView {

    // MARK: - Handler
    /// 选中回调
    public typealias xHandlerChooseItem = (Int) -> Void
    
    // MARK: - Public Property
    /// 配置
    public var config = xSegmentConfig()
    
    // MARK: - Private Property
    /// 滚动视图
    private let contentScroll = UIScrollView()
    /// 指示线
    private let lineView = UIView()
    /// 排列子视图数组
    private var itemViewArray = [UIView]()
    /// 当前选中的idx
    private var currentChooseIdx = 0
    /// 选择回调
    private var chooseHandler : xHandlerChooseItem?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
    }

    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.backgroundColor = .white
        self.addSubview(self.contentScroll)
        self.contentScroll.showsVerticalScrollIndicator = false
        self.contentScroll.showsHorizontalScrollIndicator = false
        // 其他
        self.contentScroll.addSubview(self.lineView)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.itemViewArray.count > 0 else { return }
        // 更新UI
        self.contentScroll.frame = self.bounds
        var totalWidth = CGFloat.zero
        let scrolWdith = self.bounds.width
        let count = CGFloat(self.itemViewArray.count)
        let spacing = self.config.spacing   // 间距
        let equalWidth = (scrolWdith - spacing * (count - 1)) / count
        var frame = CGRect.zero
        self.itemViewArray.forEach {
            (view) in
            // 设置frame
            switch self.config.fillMode {
            case .auto:
                frame.size.width = view.bounds.width
            case .fillEqually:
                frame.size.width = equalWidth
            }
            frame.size.height = view.bounds.height
            frame.origin.y = (self.bounds.height - frame.height) / 2
            view.frame = frame
            // 更新frame
            totalWidth += (frame.width + spacing)
            frame.origin.x = totalWidth
        }
        totalWidth -= spacing
        self.contentScroll.contentSize = .init(width: totalWidth, height: 0)
        self.contentScroll.isScrollEnabled = totalWidth > scrolWdith
    }

    // MARK: - Public Func
    // TODO: 数据加载
    /// 加载默认组件数据
    /// - Parameters:
    ///   - titleArray: 标题
    ///   - fillMode: 填充方式
    ///   - fontSize: 字号
    ///   - handler: 回调
    public func reload(titleArray : [String],
                       fillMode : xSegmentConfig.xSegmentItemFillMode,
                       fontSize : CGFloat = 15,
                       chooseItem handler : @escaping xHandlerChooseItem)
    {
        self.config.fillMode = fillMode
        var itemViewArray = [UIView]()
        for title in titleArray {
            let lbl = UILabel()
            lbl.text = title // 填充
            lbl.textAlignment = .center
            let size = lbl.xGetContentSize(margin: .init(top: 0, left: 8, bottom: 0, right: 8))
            lbl.frame = .init(origin: .zero, size: size)
            lbl.font = .systemFont(ofSize: fontSize)
            itemViewArray.append(lbl)
        }
        self.reload(itemViewArray: itemViewArray, chooseItem: handler)
    }
    /// 加载自定义组件数据(view的frame自己设)
    /// - Parameters:
    ///   - itemViewArray: 视图列表
    ///   - handler: 回调
    public func reload(itemViewArray : [UIView],
                       chooseItem handler : @escaping xHandlerChooseItem)
    {
        guard itemViewArray.count > 0 else {
            xWarning("数据不能为0")
            return
        }
        self.clearOldSegmentItem()
        // 绑定数据
        self.itemViewArray = itemViewArray
        self.chooseHandler = handler
        // 排列控件
        let cfg = self.config
        for (i, view) in itemViewArray.enumerated()
        {
            view.tag = i
            // 设置初始样式
            view.layer.masksToBounds = true
            view.layer.cornerRadius = cfg.border.cornerRadius
            view.layer.borderWidth = cfg.border.width
            view.layer.borderColor = cfg.border.color.normal.cgColor
            view.backgroundColor = cfg.backgroundColor.normal
            if let btn = view as? UIButton {
                btn.setTitleColor(cfg.titleColor.normal, for: .normal)
            }
            if let lbl = view as? UILabel {
                lbl.textColor = cfg.titleColor.normal
            }
            // 添加响应手势
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            view.addGestureRecognizer(tap)
            self.contentScroll.addSubview(view)
        }
        self.lineView.frame = .zero
        self.lineView.backgroundColor = cfg.line.color
        self.contentScroll.bringSubviewToFront(self.lineView)
        self.setNeedsLayout()
    }
    // TODO: 选中样式
    /// 选中
    public func choose(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        self.updateSegmentStyle(choose: idx)
        self.chooseHandler?(idx)
    }
    /// 更新选中样式
    public func updateSegmentStyle(choose idx : Int)
    {
        self.resetItemNormalStyle(at: self.currentChooseIdx)
        self.resetItemChooseStyle(at: idx)
        
        self.currentChooseIdx = idx // 保存idx
        self.layoutIfNeeded()   // 更新控件约束
        
        self.resetLineFrame(at: idx)
        self.resetScrollOffset(at: idx)
    }
    /// 设置普通样式
    public func resetItemNormalStyle(at idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        
        let cfg = self.config
        let item = self.itemViewArray[idx]
        item.backgroundColor = cfg.backgroundColor.normal
        item.layer.borderColor = cfg.border.color.normal.cgColor
        if let btn = item as? UIButton {
            btn.setTitleColor(cfg.titleColor.normal, for: .normal)
        }
        if let lbl = item as? UILabel {
            lbl.textColor = cfg.titleColor.normal
        }
    }
    /// 设置选中样式
    public func resetItemChooseStyle(at idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        
        let cfg = self.config
        let item = self.itemViewArray[idx]
        item.backgroundColor = cfg.backgroundColor.choose
        item.layer.borderColor = cfg.border.color.choose.cgColor
        if let btn = item as? UIButton {
            btn.setTitleColor(cfg.titleColor.choose, for: .normal)
        }
        if let lbl = item as? UILabel {
            lbl.textColor = cfg.titleColor.choose
        }
    }
    /// 重置指示线位置（直接跳过去）
    public func resetLineFrame(at idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        
        let item = self.itemViewArray[idx]
        let cfg = self.config
        var frame = self.lineView.frame
        if frame == .zero {
            frame = self.bounds
            frame.origin.y = xScreenHeight
            frame.size.width = 0
            frame.size.height = cfg.line.height
            self.lineView.frame = frame
        }
        frame.size.width = cfg.line.widthOfItemPercent * item.bounds.width
        frame.origin.x = item.frame.origin.x + (item.bounds.width - frame.size.width) / 2
        frame.origin.y = self.bounds.height - cfg.line.height
        UIView.animate(withDuration: 0.25, animations: {
            self.lineView.frame = frame
        })
    }
    /// 重置滚动结果位置（边缘处理）
    public func resetScrollOffset(at idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        guard self.config.fillMode == .auto else { return }
        
        let totalWidth = self.contentScroll.contentSize.width
        let scrolWidth = self.contentScroll.bounds.width
        var offset = CGPoint.zero
        // 单页就能显示完，不用管
        guard totalWidth >= scrolWidth else { return }
        // 第1、2个数据
        if idx <= 1 {
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        // 最后两个数据
        if idx >= self.itemViewArray.count - 2 {
            offset.x = totalWidth - scrolWidth
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        let item = self.itemViewArray[idx]
        let spacing = self.config.spacing
        let scrolX = self.contentScroll.contentOffset.x
        let itemX = item.frame.origin.x
        let itemWidth = item.frame.width
        if itemX < scrolX {
            // 左侧超出
            offset.x = itemX - spacing
            offset.x -= itemWidth   // 显示上一个item
            self.contentScroll.setContentOffset(offset, animated: true)
        }
        else
        if itemX + itemWidth >= scrolX + scrolWidth - spacing {
            // 右侧超出
            offset.x = itemX + itemWidth + spacing - scrolWidth
            offset.x += itemWidth   // 显示下一个item
            self.contentScroll.setContentOffset(offset, animated: true)
        }
    }
    
    // MARK: - Private Func
    // TODO: 清除控件
    /// 清空旧分段控件
    private func clearOldSegmentItem()
    {
        self.itemViewArray.forEach {
            (view) in
            view.removeFromSuperview()
        }
        self.itemViewArray.removeAll()
        self.lineView.frame = .zero
    }
    // TODO: 手势事件
    /// 手势事件
    @objc private func tapItem(_ gesture : UITapGestureRecognizer)
    {
        let idx = gesture.view?.tag ?? 0
        self.choose(idx: idx)
    }
}
