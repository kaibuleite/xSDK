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
    /// 子视图是否等宽
    private var isEqualItemWidth = false
    /// 选择回调
    private var chooseHandler : xHandlerChooseItem?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
    }

    // MARK: - Public Override Func
    public override func addKit() {
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
        // 更新UI
        var frame = self.bounds
        self.contentScroll.frame = frame
        var totalWidth = CGFloat.zero
        let scrolWdith = frame.width
        let count = CGFloat(self.itemViewArray.count)
        let margin = self.config.itemsMargin
        let equalWidth = (scrolWdith - margin * (count - 1)) / count
        self.itemViewArray.forEach {
            (view) in
            if self.isEqualItemWidth {
                frame.size.width = equalWidth // 等宽
            } else {
                frame.size.width = view.bounds.width
            }
            view.frame = frame
            totalWidth += (frame.width + margin)
            frame.origin.x = totalWidth
        }
        totalWidth -= self.config.itemsMargin
        self.contentScroll.contentSize = .init(width: totalWidth, height: 0)
        self.contentScroll.isScrollEnabled = totalWidth > scrolWdith
    }

    // MARK: - Public Func
    /// 加载默认分段数据
    /// - Parameters:
    ///   - titleArray: 标题
    ///   - isEqualItemWidth: 是否等宽
    ///   - fontSize: 字号
    ///   - handler: 回调
    public func reload(titleArray : [String],
                       isEqualItemWidth : Bool,
                       fontSize : CGFloat = 15,
                       chooseItem handler : @escaping xHandlerChooseItem)
    {
        self.isEqualItemWidth = isEqualItemWidth
        var itemViewArray = [UIView]()
        for title in titleArray {
            let lbl = UILabel()
            lbl.text = title // 填充
            lbl.textAlignment = .center
            lbl.frame = .zero
            if isEqualItemWidth == false {
                let size = lbl.x_getContentSize()
                lbl.frame = .init(origin: .zero, size: size)
            }
            lbl.font = .systemFont(ofSize: fontSize)
            itemViewArray.append(lbl)
        }
        self.reload(itemViewArray: itemViewArray, chooseItem: handler)
    }
    /// 加载自定义分段数据(view的frame自己设)
    /// - Parameters:
    ///   - itemViewArray: 视图列表
    ///   - handler: 回调
    public func reload(itemViewArray : [UIView],
                       chooseItem handler : @escaping xHandlerChooseItem)
    {
        guard itemViewArray.count > 0 else {
            x_warning("数据不能为0")
            return
        }
        self.lineView.backgroundColor = self.config.lineColor
        self.clearOldSegmentItem()
        self.chooseHandler = handler
        // 排列控件
        let cfg = self.config
        for (i, view) in itemViewArray.enumerated()
        {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = cfg.cornerRadius
            view.layer.borderWidth = cfg.borderWidth
            view.layer.borderColor = cfg.itemNormalBorderColor.cgColor
            view.backgroundColor = cfg.itemNormalBackgroundColor
            if let btn = view as? UIButton {
                btn.setTitleColor(cfg.itemNormalTitleColor, for: .normal)
            }
            if let lbl = view as? UILabel {
                lbl.textColor = cfg.itemNormalTitleColor
            }
            
            view.tag = i
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            view.addGestureRecognizer(tap)
            
            self.itemViewArray.append(view)
            self.contentScroll.addSubview(view)
        }
        self.layoutIfNeeded()
    }
    /// 选中
    public func choose(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        self.setChooseStyleWith(idx: idx)
        self.chooseHandler?(idx)
    }
    /// 设置选中样式
    public func setChooseStyleWith(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        self.layoutIfNeeded()
        let cfg = self.config
        // 旧的视图
        let item1 = self.itemViewArray[self.currentChooseIdx]
        item1.backgroundColor = cfg.itemNormalBackgroundColor
        item1.layer.borderColor = cfg.itemNormalBorderColor.cgColor
        if let btn = item1 as? UIButton {
            btn.setTitleColor(cfg.itemNormalTitleColor, for: .normal)
        }
        if let lbl = item1 as? UILabel {
            lbl.textColor = cfg.itemNormalTitleColor
        }
        // 新选中的视图
        let item2 = self.itemViewArray[idx]
        item2.backgroundColor = cfg.itemChooseBackgroundColor
        item2.layer.borderColor = cfg.itemChooseBorderColor.cgColor
        if let btn = item2 as? UIButton {
            btn.setTitleColor(cfg.itemChooseTitleColor, for: .normal)
        }
        if let lbl = item2 as? UILabel {
            lbl.textColor = cfg.itemChooseTitleColor
        }
        self.currentChooseIdx = idx
        // 指示线
        var lineFrame1 = item2.frame
        lineFrame1.origin.y = lineFrame1.height - cfg.lineHeight
        lineFrame1.size.height = cfg.lineHeight
        if self.lineView.frame == .zero {
            var lineFrame2 = lineFrame1
            lineFrame2.size.width = 0
            self.lineView.frame = lineFrame2
        }
        UIView.animate(withDuration: 0.25, animations: {
            [unowned self] in
            self.lineView.frame = lineFrame1
        })
        // 最终位置
        let totalWidth = self.contentScroll.contentSize.width
        let scrolWidth = self.contentScroll.bounds.width
        var offset = CGPoint.zero
        guard totalWidth > scrolWidth else { return }
        if idx <= 1 {
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        if idx >= self.itemViewArray.count - 2 {
            offset.x = totalWidth - scrolWidth
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        let scrolOfx = self.contentScroll.contentOffset.x
        let newOfx = item2.frame.origin.x
        let newWidth = item2.frame.width
        if newOfx < scrolOfx {
            // 左侧超出
            offset.x = newOfx - cfg.itemsMargin - newWidth
            self.contentScroll.setContentOffset(offset, animated: true)
        }
        else
        if newOfx + newWidth >= scrolOfx + scrolWidth - cfg.itemsMargin - 1 {
            // 右侧超出
            offset.x = newOfx + newWidth + cfg.itemsMargin + newWidth - scrolWidth
            self.contentScroll.setContentOffset(offset, animated: true)
        }
    }
    
    // MARK: - Private Func
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
    /// 手势事件
    @objc private func tapItem(_ gesture : UITapGestureRecognizer)
    {
        let idx = gesture.view?.tag ?? 0
        self.choose(idx: idx)
    }
}
