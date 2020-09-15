//
//  xTextView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xTextView: UITextView {
    
    // MARK: - IBInspectable Property
    /// 占位字符串
    @IBInspectable
    public var placeholderString : String? = ""
    
    // MARK: - Public Property
    /// 输入内容
    open override var text: String! {
        didSet {
            self.placeholderTextView.isHidden = self.text.count != 0
        }
    }
    
    // MARK: - Private Property
    /// 占位字符串控件
    private let placeholderTextView = UITextView()
    /// 自定义键盘扩展视图
    private var accessoryView : xInputAccessoryView?
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderTextView.frame = self.bounds
    }
    
    // MARK: - Public Override Func
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setContentKit()
    }
    
    // MARK: - Open Func
    /// 自定义键盘扩展视图
    open func loadAccessoryView() -> xInputAccessoryView?
    {
        let view = xInputAccessoryView.loadNib()
        return view
    }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func setContentKit()
    {
        let txt = self.placeholderTextView
        txt.backgroundColor = UIColor.clear
        txt.textColor = .x_hex("C4C4C6")
        txt.font = self.font
        txt.isUserInteractionEnabled = false
        self.addSubview(txt)
    }
}
