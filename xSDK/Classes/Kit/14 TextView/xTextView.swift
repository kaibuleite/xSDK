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
    @IBInspectable public var placeholderString : String? = "" {
        didSet {
            self.placeholderTextView.text = self.placeholderString
        }
    }
    /// 最长内容
    @IBInspectable public var maxTextCount : Int = 100
    
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
    
    // MARK: - 内存释放
    deinit {
        self.delegate = nil
    }
    
    // MARK: - Open Func
    /// 视图已加载
    open func viewDidLoad() {
        // 占位符
        let txt = self.placeholderTextView
        txt.text = self.placeholderString
        txt.backgroundColor = UIColor.clear
        txt.textColor = .xNew(hex: "C4C4C6")
        txt.font = self.font
        txt.isUserInteractionEnabled = false
        self.addSubview(txt)
        self.delegate = self
        // 附加菜单事件
        guard let view = self.loadAccessoryView() else { return }
        self.accessoryView = view
        self.inputAccessoryView = view
        view.previousBtn.isEnabled = false
        view.nextBtn.isEnabled = false
        view.completedBtn.xAddClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.endEditing(true)
        }
    }
    /// 视图已显示（GCD调用）
    open func viewDidAppear() { }
    /// 自定义键盘扩展视图
    open func loadAccessoryView() -> xInputAccessoryView?
    {
        let view = xInputAccessoryView.loadNib()
        return view
    }
    
    // MARK: - Private Func
    /// 检查内容
    private func checkText() {
        let count = self.text.count
        self.placeholderTextView.isHidden = (count != 0)
        if count > self.maxTextCount {
            xMessageAlert.display(message: "内容不能超过100字")
            let str = self.text.xSubPrefix(length: self.maxTextCount)
            self.text = str
        }
    }
    /// 设置内容UI
    private func initCompleted()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isInitCompleted == false else { return }
        
        self.viewDidLoad()
        DispatchQueue.main.async {
            self.viewDidAppear()
        }
        
        self.isInitCompleted = true
        objc_sync_exit(self)
    }
}

extension xTextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.checkText()
    }
    public func textViewDidChange(_ textView: UITextView) {
        self.checkText()
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.checkText()
    }
}
