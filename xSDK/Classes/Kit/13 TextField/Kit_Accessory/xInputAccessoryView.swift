//
//  xInputAccessoryView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xInputAccessoryView: UIView {
    
    // MARK: - 关联变量
    /// 上一个
    @IBOutlet weak var previousBtn: UIButton!
    /// 下一个
    @IBOutlet weak var nextBtn: UIButton!
    /// 完成
    @IBOutlet weak var completedBtn: UIButton!
    /// 文本内容
    @IBOutlet weak var textLbl: UILabel!
    
    // MARK: - 实例化对象
    class func loadNib() -> xInputAccessoryView {
        let bundle = Bundle.init(for: self.classForCoder())
        let arr = bundle.loadNibNamed("xInputAccessoryView", owner: nil, options: nil)!
        let view = arr.first! as! xInputAccessoryView
        var frame = CGRect.zero
        frame.size.width = x_width
        frame.size.height = 44.0
        view.frame = frame
        return view
    }
    
    // MARK: - 视图加载
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
