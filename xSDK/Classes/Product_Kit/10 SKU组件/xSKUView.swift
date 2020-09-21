//
//  xSKUView.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xSKUView: xView {

    // MARK: - Handler
    /// 选中Sku item回调
    public typealias xHandlerChooseItem = (Int) -> Void
    /// 刷新数据回调，返回尺寸
    public typealias xHandlerReloadData = (CGRect) -> Void
    
    // MARK: - Public Property
    /// 参数配置
    public var config = xSKUConfig()
    
    // MARK: - Private Property
    /// 子控件
    private var itemViewArray = [UIButton]()
    /// 选择回调
    private var chooseHandler : xHandlerChooseItem?
    /// 刷新回调
    private var reloadDataHandler : xHandlerReloadData?
    /// 当期那选中item
    private var currentChooseIdx = Int.zero
    /// 等宽分列（0表示自适应宽度）
    private var column = 0
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.reloadDataHandler = nil
    }
    
    // MARK: - Public Override Func
    // 更新UI
    public override func layoutSubviews() {
        super.layoutSubviews()
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
                var size = item.titleLabel?.x_getContentSize() ?? .zero
                size.width += 16    // 左右留空
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
        self.reloadDataHandler?(ret)
    }
    
    // MARK: - Public Func
    /// 加载规格数据(排版需要调用下边的方法)
    /// - Parameters:
    ///   - dataArray: 数据源
    ///   - column: 等宽分列,默认自适应
    ///   - handler: 回调
    public func reload(dataArray : [String],
                       column : Int = 0,
                       handler : @escaping xHandlerReloadData)
    {
        guard dataArray.count > 0 else {
            x_warning("数据不能为0")
            return
        }
        self.clearOldSkuItem()
        self.column = column
        self.reloadDataHandler = handler
        // 添加规格控件
        let cfg = self.config
        for (i, title) in dataArray.enumerated()
        {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: cfg.fontSize)
            btn.contentHorizontalAlignment = .center
            btn.layer.cornerRadius = cfg.cornerRadius
            btn.layer.borderWidth = cfg.borderWidth
            btn.backgroundColor = cfg.itemNormalBackgroundColor
            btn.layer.borderColor = cfg.itemNormalBorderColor.cgColor
            btn.setTitleColor(cfg.itemNormalTitleColor, for: .normal)
            // 添加响应事件
            btn.x_addClick {
                [unowned self] (sender) in
                self.choose(idx: sender.tag)
            }
            self.addSubview(btn)
            self.itemViewArray.append(btn)
        }
        self.layoutIfNeeded()
    }
    /// 添加选择回调
    public func addChooseHandler(_ handler : @escaping xHandlerChooseItem)
    {
        self.chooseHandler = handler
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
        let item1 = self.itemViewArray[self.currentChooseIdx]
        item1.backgroundColor = cfg.itemNormalBackgroundColor
        item1.layer.borderColor = cfg.itemNormalBorderColor.cgColor
        item1.setTitleColor(cfg.itemNormalTitleColor, for: .normal)
        // 新选中的视图
        let item2 = self.itemViewArray[idx]
        item2.backgroundColor = cfg.itemChooseBackgroundColor
        item2.layer.borderColor = cfg.itemChooseBorderColor.cgColor
        item2.setTitleColor(cfg.itemChooseTitleColor, for: .normal)
        self.currentChooseIdx = idx
    }

    // MARK: - Private Func
    /// 清空旧规格控件
    private func clearOldSkuItem()
    {
        for item in self.itemViewArray {
            item.x_removeClickHandler()
            item.removeFromSuperview()
        }
        self.itemViewArray.removeAll()
    }
}
