//
//  xInputAccessoryView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xInputAccessoryView: UIView {
    
    // MARK: - IBOutlet Property
    /// 上一个
    @IBOutlet weak var previousBtn: UIButton!
    /// 下一个
    @IBOutlet weak var nextBtn: UIButton!
    /// 完成
    @IBOutlet weak var completedBtn: UIButton!
    /// 文本内容
    @IBOutlet weak var textLbl: UILabel!
    
    // MARK: - Public Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Func
    public class func loadNib() -> xInputAccessoryView {
        let bundle = Bundle.init(for: self.classForCoder())
        let arr = bundle.loadNibNamed("xInputAccessoryView", owner: nil, options: nil)!
        let view = arr.first! as! xInputAccessoryView
        var frame = CGRect.zero
        frame.size.width = x_width
        frame.size.height = 44.0
        view.frame = frame
        return view
    }
    
}
