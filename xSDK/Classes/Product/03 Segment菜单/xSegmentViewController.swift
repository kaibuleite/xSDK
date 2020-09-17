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
        for (i, view) in itemViewArray.enumerated()
        {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = self.config.cornerRadius
            view.layer.borderWidth = self.config.borderWidth
            view.layer.borderColor = self.config.itemNormalBorderColor.cgColor
            view.backgroundColor = self.config.itemNormalBackgroundColor
            if let btn = view as? UIButton {
                btn.setTitleColor(self.config.itemNormalTitleColor, for: .normal)
            }
            if let lbl = view as? UILabel {
                lbl.textColor = self.config.itemNormalTitleColor
            }
            
            view.tag = i
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapItem(_:)))
            view.addGestureRecognizer(tap)
            
            // 测试
            view.backgroundColor = .x_random()
            
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
        
        let config = self.config
        let old = self.itemViewArray[self.currentChooseIdx]
        old.backgroundColor = config.itemNormalBackgroundColor
        old.layer.borderColor = config.itemNormalBorderColor.cgColor
        if let btn = old as? UIButton {
            btn.setTitleColor(config.itemNormalTitleColor, for: .normal)
        }
        if let lbl = old as? UILabel {
            lbl.textColor = config.itemNormalTitleColor
        }
        
        let new = self.itemViewArray[idx]
        new.backgroundColor = config.itemSelectedBackgroundColor
        new.layer.borderColor = config.itemSelectedBorderColor.cgColor
        if let btn = old as? UIButton {
            btn.setTitleColor(config.itemSelectedTitleColor, for: .normal)
        }
        if let lbl = new as? UILabel {
            lbl.textColor = config.itemSelectedTitleColor
        }
        
        self.currentChooseIdx = idx
        
        self.view.layoutIfNeeded()
        var frame = new.frame
        frame.origin.y = frame.height - self.config.lineHeight
        frame.size.height = self.config.lineHeight
        if self.lineView.frame == .zero {
            var frame2 = frame
            frame2.size.width = 0
            self.lineView.frame = frame2
        }
        UIView.animate(withDuration: 0.25, animations: {
            [unowned self] in
            self.lineView.frame = frame
        })
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
