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
    @IBOutlet public weak var backBtn: UIButton!
    /// 标题标签
    @IBOutlet public weak  var titleLbl: UILabel!
    
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
    @IBInspectable var title : String? {
        didSet {
            self.titleLbl.text = self.title
        }
    }
    /// 标题颜色
    @IBInspectable var titleColor: UIColor = .darkText {
        didSet {
            self.titleLbl.textColor = self.titleColor
        }
    }
    /// 导航栏颜色
    @IBInspectable var barColor : UIColor = xNavigationBarColor {
        didSet {
            self.backgroundColor = self.barColor
        }
    }
    
    // MARK: - 重载方法
    override func setGlobalStyle() {
        super.setGlobalStyle()
        self.backgroundColor = self.barColor
        // 优先显示绑定的视图控制器title
        if let title = self.vc?.title {
            self.titleLbl.text = title
        } else {
            self.titleLbl.text = self.title
        }
        self.titleLbl.textColor = self.titleColor
        self.backBtn.isHidden = !self.isShowBackBtn
    }
    
    // MARK: - 返回
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.xibView.endEditing(true)
        guard let nvc = self.vc?.navigationController else {
            // 尝试模态退出
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
