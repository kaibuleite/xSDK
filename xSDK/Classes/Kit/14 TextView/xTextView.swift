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
    @IBInspectable public var placeholderString : String? = ""
    
    // MARK: - Public Property
    /// 输入内容
    open override var text: String! {
        didSet {
            self.placeholderTextView.isHidden = self.text.count != 0
        }
    }
    
    // MARK: - Private Property
    /// 是否加载过样式
    private var isInitCompleted = false
    /// 占位字符串控件
    private let placeholderTextView = UITextView()
    /// 自定义键盘扩展视图
    private var accessoryView : xInputAccessoryView?
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initCompleted()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // 如果没有实现awakeFromNib，则会调用该方法
        self.initCompleted()
    }
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.initCompleted()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderTextView.frame = self.bounds
    }
    
    // MARK: - Open Func
    /// 视图已加载
    open func viewDidLoad() {
        let txt = self.placeholderTextView
        txt.backgroundColor = UIColor.clear
        txt.textColor = .xNew(hex: "C4C4C6")
        txt.font = self.font
        txt.isUserInteractionEnabled = false
        self.addSubview(txt)
    }
    /// 视图已显示（GCD调用）
    open func viewDidDisappear() { }
    /// 自定义键盘扩展视图
    open func loadAccessoryView() -> xInputAccessoryView?
    {
        let view = xInputAccessoryView.loadNib()
        return view
    }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func initCompleted()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isInitCompleted == false else { return }
        
        self.viewDidLoad()
        DispatchQueue.main.async {
            self.viewDidDisappear()
        }
        
        self.isInitCompleted = true
        objc_sync_exit(self)
    }
}
