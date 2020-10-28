//
//  xSegmentViewNew.swift
//  xSDK
//
//  Created by Mac on 2020/10/28.
//

import UIKit

public class xSegmentViewNew: xNibView {

    // MARK: - Handler
    /// 选中回调
    public typealias xHandlerChooseItem = (Int) -> Void
    
    // MARK: - Public Property
    /// 配置
    public var config = xSegmentConfigNew()
    
    // MARK: - Private Property
    /// 滚动视图
    private let contentScroll = UIScrollView()
    /// 堆叠视图
    private let containerStack = UIStackView()
    
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
    public override func viewDidDisappear() {
        // 基本配置
        self.backgroundColor = .white
        // 滚动容器
        self.setNeedsLayout()
        self.addSubview(self.contentScroll)
        self.contentScroll.showsVerticalScrollIndicator = false
        self.contentScroll.showsHorizontalScrollIndicator = false
        // 堆叠容器
        self.contentScroll.addSubview(self.containerStack)
        self.containerStack.axis = .horizontal
        self.containerStack.xAddWidthLayout(constant: 1000)
        // 其他
        
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.itemViewArray.count > 0 else { return }
        let frame = self.bounds
        self.contentScroll.frame = frame
        self.containerStack.setNeedsLayout()
        xLog(self.containerStack.frame)
        self.contentScroll.contentSize = self.containerStack.bounds.size
        
    }

    // MARK: - Public Func
    /// 更新配置
    /// - Parameter config: 新配置
    public func update(config: xSegmentConfigNew)
    {
        self.config = config
        self.containerStack.spacing = config.spacing
        self.containerStack.distribution = config.distribution
        self.layoutIfNeeded()
    }
    
    /// 加载默认组件数据
    /// - Parameters:
    ///   - titleArray: 标题
    ///   - isEqualItemWidth: 是否等宽
    ///   - fontSize: 字号
    ///   - handler: 回调
    public func reload(titleArray : [String],
                       fontSize : CGFloat = 15,
                       chooseItem handler : @escaping xHandlerChooseItem)
    {
        var itemViewArray = [UIView]()
        let font = UIFont.systemFont(ofSize: fontSize)
        for title in titleArray {
            let lbl = UILabel()
            lbl.text = title
            lbl.textAlignment = .center
            lbl.font = font
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
            view.layer.masksToBounds = true
            view.layer.cornerRadius = cfg.border.cornerRadius
            view.layer.borderWidth = cfg.border.lineWidth
            view.layer.borderColor = cfg.border.color.normal.cgColor
            view.backgroundColor = cfg.backgroundColor.normal
            if let btn = view as? UIButton {
                btn.setTitleColor(cfg.titleColor.normal, for: .normal)
            }
            if let lbl = view as? UILabel {
                lbl.textColor = cfg.titleColor.normal
            }
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            view.addGestureRecognizer(tap)
            view.xAddWidthLayout(constant: 50, relatedBy: .equal)
            view.xAddHeightLayout(constant: 30, relatedBy: .equal)
            view.setNeedsLayout()
            xLog(view.frame)
            self.containerStack.addArrangedSubview(view)
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
        item1.backgroundColor = cfg.backgroundColor.normal
        item1.layer.borderColor = cfg.border.color.normal.cgColor
        if let btn = item1 as? UIButton {
            btn.setTitleColor(cfg.titleColor.normal, for: .normal)
        }
        if let lbl = item1 as? UILabel {
            lbl.textColor = cfg.titleColor.normal
        }
        // 新选中的视图
        let item2 = self.itemViewArray[idx]
        item2.backgroundColor = cfg.backgroundColor.choose
        item2.layer.borderColor = cfg.border.color.choose.cgColor
        if let btn = item2 as? UIButton {
            btn.setTitleColor(cfg.titleColor.choose, for: .normal)
        }
        if let lbl = item2 as? UILabel {
            lbl.textColor = cfg.titleColor.choose
        }
        self.currentChooseIdx = idx
    }
    
    // MARK: - Private Func
    /// 清空旧分段控件
    private func clearOldSegmentItem()
    {
        for item in self.containerStack.subviews {
            self.containerStack.removeArrangedSubview(item)
        }
        self.itemViewArray.removeAll()
    }
    /// 手势事件
    @objc private func tapItem(_ gesture : UITapGestureRecognizer)
    {
        let idx = gesture.view?.tag ?? 0
        self.choose(idx: idx)
    }
}
