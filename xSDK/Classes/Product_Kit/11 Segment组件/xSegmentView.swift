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
    /// 当前选中的idx
    public var currentChooseIdx = 0
    /// 排列子视图数组
    public var itemViewArray = [UIView]()
    /// 滚动视图
    public let contentScroll = UIScrollView()
    
    // MARK: - Private Property
    /// 指示线图层
    let lineLayer = CAShapeLayer.init()
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
        // 滚动容器
        self.addSubview(self.contentScroll)
        self.contentScroll.showsVerticalScrollIndicator = false
        self.contentScroll.showsHorizontalScrollIndicator = false
        // 添加响应手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapContentScroll(_:)))
        self.contentScroll.addGestureRecognizer(tap)
        self.contentScroll.isUserInteractionEnabled = true
        // 指示线
        self.lineLayer.lineCap = .round
        self.lineLayer.lineJoin = .round
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.contentScroll.layer.addSublayer(self.lineLayer)
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
        let contentSize = CGSize.init(width: totalWidth, height: 0)
        self.contentScroll.contentSize = contentSize
        self.contentScroll.isScrollEnabled = totalWidth > scrolWdith
        self.lineLayer.frame = .init(origin: .zero, size: contentSize)
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
            self.contentScroll.addSubview(view)
        }
        self.lineLayer.lineWidth = cfg.line.height
        self.lineLayer.strokeColor = cfg.line.color.cgColor
        
        self.setNeedsLayout()
    }
    // TODO: 选中样式
    /// 选中
    public func choose(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        guard idx != self.currentChooseIdx else { return }
        self.updateSegmentStyle(choose: idx)
        self.chooseHandler?(idx)
    }
    /// 更新选中样式
    public func updateSegmentStyle(choose idx : Int)
    {
        self.setItemNormalStyle(at: self.currentChooseIdx)
        self.setItemChooseStyle(at: idx)
        
        self.currentChooseIdx = idx // 保存idx
        self.layoutIfNeeded()   // 更新控件约束
        
        self.setLineMove(to: idx)
        self.setContentSideScroll(to: idx)
    }
    /// 设置普通样式
    public func setItemNormalStyle(at idx : Int)
    {
        guard let item = self.getItem(at: idx)  else { return }
        let cfg = self.config
        item.backgroundColor = cfg.backgroundColor.normal
        item.layer.borderColor = cfg.border.color.normal.cgColor
        self.setItemTitleColor(at: idx, color: cfg.titleColor.normal)
    }
    /// 设置选中样式
    public func setItemChooseStyle(at idx : Int)
    {
        guard let item = self.getItem(at: idx)  else { return }
        let cfg = self.config
        item.backgroundColor = cfg.backgroundColor.choose
        item.layer.borderColor = cfg.border.color.choose.cgColor
        self.setItemTitleColor(at: idx, color: cfg.titleColor.choose)
    }
    
    /// 设置指定编号的Item标题颜色
    /// - Parameters:
    ///   - idx: 编号
    ///   - color: 颜色
    public func setItemTitleColor(at idx : Int,
                                  color : UIColor)
    {
        guard let item = self.getItem(at: idx)  else { return }
        if let btn = item as? UIButton {
            btn.setTitleColor(color, for: .normal)
        }
        if let lbl = item as? UILabel {
            lbl.textColor = color
        }
    }
    /// 设置指示线位置（直接跳过去）
    public func setLineMove(to idx : Int)
    {
        guard let item = self.getItem(at: idx)  else { return }
        let cfg = self.config
        let itemX = item.frame.origin.x
        let itemW = item.frame.width
        let lineW = itemW * cfg.line.widthOfItemPercent
        // 计算指示线路径
        let path = UIBezierPath.init()
        var pos = CGPoint.zero
        pos.y = self.bounds.height - cfg.line.height - cfg.line.marginBottom
        pos.x = itemX + (itemW - lineW) / 2 // 起点位置
        path.move(to: pos)
        pos.x += lineW      // 终点位置
        path.addLine(to: pos)
        self.lineLayer.path = path.cgPath 
    }
    /// 设置滚动结果位置（边缘处理）
    public func setContentSideScroll(to idx : Int)
    {
        guard self.config.fillMode == .auto else { return }
        guard let item = self.getItem(at: idx)  else { return } 
        let totalW = self.contentScroll.contentSize.width
        let scrolW = self.contentScroll.bounds.width
        var offset = CGPoint.zero
        // 单页就能显示完，不用管
        guard totalW >= scrolW else { return }
        // 第1、2个数据
        if idx <= 1 {
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        // 最后两个数据
        if idx >= self.itemViewArray.count - 2 {
            offset.x = totalW - scrolW
            self.contentScroll.setContentOffset(offset, animated: true)
            return
        }
        // 中间的数据
        let spacing = self.config.spacing
        let scrolX = self.contentScroll.contentOffset.x
        let itemX = item.frame.origin.x
        let itemW = item.frame.width
        if itemX - itemW < scrolX {
            // 左侧超出
            offset.x = itemX - spacing
            offset.x -= itemW   // 显示上一个item
            self.contentScroll.setContentOffset(offset, animated: true)
        }
        else
        if itemX + itemW + itemW >= scrolX + scrolW {
            // 右侧超出
            offset.x = itemX + itemW + spacing - scrolW
            offset.x += itemW   // 显示下一个item
            self.contentScroll.setContentOffset(offset, animated: true)
        }
    }
    
    // MARK: - Private Func
    /// 获取指定的item
    private func getItem(at idx : Int) -> UIView?
    {
        guard idx >= 0 else { return nil}
        guard idx < self.itemViewArray.count else { return nil}
        return self.itemViewArray[idx]
    }
    // TODO: 清除控件
    /// 清空旧分段控件
    private func clearOldSegmentItem()
    {
        self.itemViewArray.forEach {
            (view) in
            view.removeFromSuperview()
        }
        self.itemViewArray.removeAll()
        self.lineLayer.path = UIBezierPath.init().cgPath
    }
    // TODO: 手势事件
    /// 手势事件
    @objc private func tapContentScroll(_ gesture : UITapGestureRecognizer)
    {
        let pos = gesture.location(in: self.contentScroll)
        var idx = 0
        for item in self.itemViewArray {
            if item.frame.contains(pos) {
                idx = item.tag
                break
            }
        }
        self.choose(idx: idx)
    }
}
