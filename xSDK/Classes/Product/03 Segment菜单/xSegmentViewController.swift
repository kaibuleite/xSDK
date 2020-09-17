//
//  xSegmentViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/17.
//

import UIKit

public class xSegmentViewController: xViewController {

    // MARK: - Handler
    /// 选择分段回调
    public typealias xHandlerChooseSegmentItem = (Int) -> Void
    
    // MARK: - Public Property
    /// 配置
    public var config = xSegmentConfig()

    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xSegmentViewController.init()
        return vc as! Self
    }
    
    // MARK: - Private Property
    /// 滚动视图
    private let contentScroll = UIScrollView()
    /// 指示线
    private let lineView = UIView()
    /// 排列子视图数组
    private var itemViewArray = [UIView]()
    /// 当前选中的idx
    private var currentChooseIdx = 0
    /// 回调
    private var handler : xHandlerChooseSegmentItem?
    
    // MARK: - 内存释放
    deinit {
        self.handler = nil
    }

    // MARK: - Public Override Func
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.view.addSubview(self.contentScroll)
        self.contentScroll.showsVerticalScrollIndicator = false
        self.contentScroll.showsHorizontalScrollIndicator = false
        // 其他
        self.contentScroll.addSubview(self.lineView)
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 更新UI
        var frame = self.view.bounds
        self.contentScroll.frame = frame
        var totalWidth = CGFloat.zero
        self.itemViewArray.forEach {
            (view) in
            frame.size.width = view.bounds.width
            view.frame = frame
            totalWidth += (frame.width + self.config.itemsMargin)
            frame.origin.x = totalWidth
        }
        totalWidth -= self.config.itemsMargin
        self.contentScroll.contentSize = .init(width: totalWidth, height: 0)
    }

    // MARK: - Public Func
    /// 加载默认分段数据
    public func reload(titleArray : [String],
                       fontSize : CGFloat = 15,
                       handler : @escaping xHandlerChooseSegmentItem)
    {
        var itemViewArray = [UIView]()
        for title in titleArray {
            let lbl = UILabel()
            lbl.text = title // 填充
            lbl.textAlignment = .center
            let size = lbl.x_getContentSize()
            lbl.frame = .init(origin: .zero, size: size)
            lbl.font = .systemFont(ofSize: fontSize)
            itemViewArray.append(lbl)
        }
        self.reload(itemViewArray: itemViewArray, handler: handler)
    }
    /// 加载自定义分段数据(view的frame自己设)
    public func reload(itemViewArray : [UIView],
                       handler : @escaping xHandlerChooseSegmentItem)
    {
        guard itemViewArray.count > 0 else {
            x_warning("数据不能为0")
            return
        }
        self.lineView.backgroundColor = self.config.lineColor
        self.clearOldSegmentItem()
        self.handler = handler
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
        self.view.layoutIfNeeded()
    }
    /// 选中
    public func choose(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        self.setChooseStyleWith(idx: idx)
        self.handler?(idx)
    }
    /// 设置选中样式
    public func setChooseStyleWith(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
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
        item2.backgroundColor = cfg.itemSelectedBackgroundColor
        item2.layer.borderColor = cfg.itemSelectedBorderColor.cgColor
        if let btn = item2 as? UIButton {
            btn.setTitleColor(cfg.itemSelectedTitleColor, for: .normal)
        }
        if let lbl = item2 as? UILabel {
            lbl.textColor = cfg.itemSelectedTitleColor
        }
        self.currentChooseIdx = idx
        // 指示线
        self.view.layoutIfNeeded()
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
