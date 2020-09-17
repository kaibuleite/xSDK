//
//  xNavigationView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/16.
//

import UIKit

public class xNavigationView: xNibView {
    
    // MARK: - IBOutlet Property
    /// 返回按钮
    @IBOutlet weak var backBtn: UIButton!
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 分割线
    @IBOutlet weak var lineView: xLineView!
    
    // MARK: - IBInspectable Property
    /// 是否返回root（默认false）
    @IBInspectable
    public var isPopRootViewController : Bool = false
    /// 是否显示返回按钮
    @IBInspectable
    public var isShowBackBtn: Bool = true {
        didSet {
            self.backBtn.isHidden = !self.isShowBackBtn
        }
    }
    /// 标题
    @IBInspectable var title : String = "" {
        didSet {
            self.titleLbl.text = self.title
        }
    }
    /// 标题颜色
    @IBInspectable var titleColor: UIColor = .darkText {
        didSet {
            self.titleLbl.textColor = self.titleColor
            self.backBtn.tintColor = self.titleColor
        }
    }
    /// 分割线颜色
    @IBInspectable var lineColor: UIColor = .groupTableViewBackground {
        didSet {
            self.lineView.lineColor = self.lineColor
        }
    }
    /// 导航栏颜色
    @IBInspectable var barColor : UIColor = .white {
        didSet {
            self.backgroundColor = self.barColor
        }
    }
    
    // MARK: - Public Override Func
    public override func addKit()
    {
        super.addKit()
        self.backgroundColor = self.barColor
        self.titleLbl.textColor = self.titleColor
        self.backBtn.tintColor = self.titleColor
        self.backBtn.isHidden = !self.isShowBackBtn
        // 标题
        self.titleLbl.text = self.title
        if self.title.isEmpty {
            self.titleLbl.text = self.vc?.title
        }
    }

    // MARK: - IBAction Func
    /// 返回
    @IBAction func backBtnClick(_ sender: UIButton)
    {
        x_getKeyWindow()?.endEditing(true)
        // 尝试模态退出
        guard let nvc = self.vc?.navigationController else {
            self.vc?.dismiss(animated: true, completion: nil)
            return
        }
        if self.isPopRootViewController {
            nvc.popToRootViewController(animated: true)
        } else {
            nvc.popViewController(animated: true)
        }
    }

}
