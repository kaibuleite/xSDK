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
        let scrolWdith = frame.width
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
    /// 加载默认组件数据
    /// - Parameters:
    ///   - titleArray: 标题
    ///   - isEqualItemWidth: 是否等宽
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
        let oldItem = self.itemViewArray[self.currentChooseIdx]
        oldItem.backgroundColor = cfg.backgroundColor.normal
        oldItem.layer.borderColor = cfg.border.color.normal.cgColor
        if let btn = oldItem as? UIButton {
            btn.setTitleColor(cfg.titleColor.normal, for: .normal)
        }
        if let lbl = oldItem as? UILabel {
            lbl.textColor = cfg.titleColor.normal
        }
        // 新选中的视图
        let newItem = self.itemViewArray[idx]
        newItem.backgroundColor = cfg.backgroundColor.choose
        newItem.layer.borderColor = cfg.border.color.choose.cgColor
        if let btn = newItem as? UIButton {
            btn.setTitleColor(cfg.titleColor.choose, for: .normal)
        }
        if let lbl = newItem as? UILabel {
            lbl.textColor = cfg.titleColor.choose
        }
        self.currentChooseIdx = idx
        // 指示线
        var lineFrame = self.lineView.frame
        if lineFrame == .zero {
            lineFrame = self.bounds
            lineFrame.origin.y = frame.height - cfg.line.height
            lineFrame.size.width = 0
            lineFrame.size.height = cfg.line.height
            self.lineView.frame = lineFrame
        }
        lineFrame.size.width = cfg.line.widthOfItemPercent * newItem.bounds.width
        lineFrame.origin.x = newItem.frame.origin.x + (newItem.bounds.width - lineFrame.size.width) / 2
        UIView.animate(withDuration: 0.25, animations: {
            self.lineView.frame = lineFrame
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
        let newOfx = newItem.frame.origin.x
        let newWidth = newItem.frame.width
        if newOfx < scrolOfx {
            // 左侧超出
            offset.x = newOfx - cfg.spacing - newWidth
            self.contentScroll.setContentOffset(offset, animated: true)
        }
        else
        if newOfx + newWidth >= scrolOfx + scrolWidth - cfg.spacing - 1 {
            // 右侧超出
            offset.x = newOfx + newWidth + cfg.spacing + newWidth - scrolWidth
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
