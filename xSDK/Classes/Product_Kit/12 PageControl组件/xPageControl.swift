//
//  xPageControl.swift
//  xSDK
//
//  Created by Mac on 2020/9/22.
//

import UIKit

public class xPageControl: xNibView {

    // MARK: - IBOutlet Property
    @IBOutlet weak var pageItemStackView: UIStackView!
    
    // MARK: - IBInspectable Property
    /// 当前页码颜色
    @IBInspectable public var currentPageColor : UIColor = .red
    /// 其他页码颜色
    @IBInspectable public var otherPageColor : UIColor = .groupTableViewBackground
    /// 页码控件尺寸
    @IBInspectable public var pageItemSize : CGSize = .init(width: 6, height: 2)
    
    // MARK: - Public Property
    /// 页码数
    public var pagesCount = 0 {
        didSet {
            self.addPageItem()
        }
    }
    /// 当前页码
    public var currentPage = 0 {
        didSet {
            self.pageItemStackView.arrangedSubviews.forEach {
                [unowned self] (view) in
                if view.tag == self.currentPage {
                    view.backgroundColor = self.currentPageColor
                }
                else {
                    view.backgroundColor = self.otherPageColor
                }
            }
        }
    }
    public var pageItemSpacing : CGFloat = 5 {
        didSet {
            self.pageItemStackView.spacing = self.pageItemSpacing
        }
    }
    
    // MARK: - Private Func
    /// 清空旧页码控件
    private func clearOldPageItem()
    {
        let arr = self.pageItemStackView.arrangedSubviews
        arr.forEach {
            [unowned self] (view) in
            self.pageItemStackView.removeArrangedSubview(view)
        }
    }
    /// 添加页码控件
    private func addPageItem()
    {
        guard self.pagesCount > 0 else { return }
        self.clearOldPageItem()
        for i in 0 ..< self.pagesCount {
            let v = UIView()
            v.tag = i
            v.layer.cornerRadius = self.pageItemSize.height / 2
            v.layer.masksToBounds = true
            v.xAddWidthLayout(constant: self.pageItemSize.width)
            v.xAddHeightLayout(constant: self.pageItemSize.height)
            if i == self.currentPage {
                v.backgroundColor = self.currentPageColor
            }
            else {
                v.backgroundColor = self.otherPageColor
            }
            self.pageItemStackView.addArrangedSubview(v)
        }
        self.layoutIfNeeded()
    }
}
