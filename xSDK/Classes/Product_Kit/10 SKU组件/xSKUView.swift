//
//  xSKUView.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xSKUView: xView {

    // MARK: - Handler
    /// 选中回调
    public typealias xHandlerChooseItem = (Int) -> Void
    /// 刷新数据回调，返回尺寸
    public typealias xHandlerReloadCompleted = (CGRect) -> Void
    
    // MARK: - Public Property
    /// 配置
    public var config = xSKUConfig()
    
    // MARK: - Private Property
    /// 等宽分列（0表示自适应宽度）
    private var column = 0
    /// 子控件
    private var itemViewArray = [UIButton]()
    /// 当期那选中item
    private var currentChooseIdx = Int.zero
    /// 选择回调
    private var chooseHandler : xHandlerChooseItem?
    /// 刷新回调
    private var reloadHandler : xHandlerReloadCompleted?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.reloadHandler = nil
    }
    
    // MARK: - Public Override Func
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard self.itemViewArray.count > 0 else { return }
        // 更新UI
        let cfg = self.config
        var frame = CGRect.zero
        frame.size.height = cfg.itemHeight
        var equalWidth = CGFloat.zero
        if self.column != 0 {   // 等宽
            equalWidth = (self.frame.width - cfg.columnSpacing * CGFloat(self.column - 1)) / CGFloat(self.column)
        }
        for item in self.itemViewArray {
            if self.column != 0 {
                frame.size.width = equalWidth // 等宽
            } else {
                // 计算宽度
                let size = item.titleLabel?.xGetContentSize(margin: .init(top: 0, left: 8, bottom: 0, right: 8)) ?? .zero
                frame.size.width = size.width
            }
            if frame.origin.x + frame.width > self.bounds.width {
                // 换行
                frame.origin.x = 0
                frame.origin.y += (cfg.rowSpacing + frame.height)
            }
            item.frame = frame
            frame.origin.x += (frame.width + cfg.columnSpacing)
        }
        var ret = CGRect.zero
        ret.size.width = self.bounds.width
        ret.size.height = frame.origin.y + frame.height
        self.reloadHandler?(ret)
    }
    
    // MARK: - Public Func
    /// 加载组件数据
    /// - Parameters:
    ///   - dataArray: 数据源
    ///   - column: 等宽分列,默认自适应
    ///   - handler: 回调
    public func reload(dataArray : [String],
                       column : Int = 0,
                       completed handler1 : @escaping xHandlerReloadCompleted,
                       choose handler2 : @escaping xHandlerChooseItem)
    {
        guard dataArray.count > 0 else {
            xWarning("木有数据")
            return
        }
        self.clearOldSkuItem()
        self.column = column
        self.reloadHandler = handler1
        self.chooseHandler = handler2
        // 添加规格控件
        let cfg = self.config
        let font = UIFont.systemFont(ofSize: cfg.fontSize)
        for (i, title) in dataArray.enumerated()
        {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = font
            btn.contentHorizontalAlignment = .center
            btn.layer.cornerRadius = cfg.cornerRadius
            btn.layer.borderWidth = cfg.borderWidth
            btn.backgroundColor = cfg.itemBackgroundNormalColor
            btn.layer.borderColor = cfg.itemBorderNormalColor.cgColor
            btn.setTitleColor(cfg.itemTitleNormalColor, for: .normal)
            // 添加响应事件
            btn.xAddClick {
                [unowned self] (sender) in
                self.choose(idx: sender.tag)
            }
            self.addSubview(btn)
            self.itemViewArray.append(btn)
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
    /// 设置为选中样式
    public func setChooseStyleWith(idx : Int)
    {
        guard idx >= 0 else { return }
        guard idx < self.itemViewArray.count else { return }
        self.layoutIfNeeded()
        let cfg = self.config
        // 旧的视图
        let oldItem = self.itemViewArray[self.currentChooseIdx]
        oldItem.backgroundColor = cfg.itemBackgroundNormalColor
        oldItem.layer.borderColor = cfg.itemBorderNormalColor.cgColor
        oldItem.setTitleColor(cfg.itemTitleNormalColor, for: .normal)
        // 新选中的视图
        let newItem = self.itemViewArray[idx]
        newItem.backgroundColor = cfg.itemBackgroundChooseColor
        newItem.layer.borderColor = cfg.itemBorderChooseColor.cgColor
        newItem.setTitleColor(cfg.itemTitleChooseColor, for: .normal)
        self.currentChooseIdx = idx
    }

    // MARK: - Private Func
    /// 清空旧规格控件
    private func clearOldSkuItem()
    {
        for item in self.itemViewArray {
            item.xRemoveClickHandler()
            item.removeFromSuperview()
        }
        self.itemViewArray.removeAll()
    }
}
