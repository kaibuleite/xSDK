//
//  xTextField.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xTextField: UITextField, UITextFieldDelegate {
    
    // MARK: - Handler
    /// 输入框内容回调
    public typealias xHandlerTextFieldInput = (String) -> Void
    /// 输入框状态回调
    public typealias xHandlerTextFieldChangeStatus = () -> Void
    
    // MARK: - IBInspectable Property
    /// 容器
    @IBInspectable public var container : UIView?
    /// 容器边框默认颜色
    @IBInspectable public var containerBoardNomalColor : UIColor = .xNew(hex: "E5E5E5")
    /// 边框选中颜色
    @IBInspectable public var containerBoardChooseColor : UIColor = .xNew(hex: "EB0A1E")
    
    // MARK: - Public Property
    /// 上一个输入框
    public weak var previousInput : xTextField?
    /// 下一个输入框
    public weak var nextInput : xTextField?
    
    // MARK: - Private Property
    /// 是否加载过样式
    private var isInitCompleted = false
    /// 自定义键盘扩展视图
    private var accessoryView : xInputAccessoryView?
    /// 开始编辑回调
    private var beginEditHandler : xHandlerTextFieldChangeStatus?
    /// 编辑中回调
    private var editingHandler : xHandlerTextFieldInput?
    /// 编辑结束回调
    private var endEditHandler : xHandlerTextFieldChangeStatus?
    /// return按钮回调
    private var returnHandler : xHandlerTextFieldChangeStatus?
    
    // MARK: - 内存释放
    deinit {
        self.beginEditHandler = nil
        self.editingHandler = nil
        self.endEditHandler = nil
        self.returnHandler = nil
        self.previousInput = nil
        self.nextInput = nil
        self.delegate = nil
    }
    
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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCompleted()
    }
    
    // MARK: - Open Func
    /// 视图已加载
    open func viewDidLoad() {
        self.delegate = self
        // 编辑事件
        self.addTarget(self, action: #selector(textChanged),
                       for: .editingChanged)
        // 附加菜单事件
        guard let view = self.loadAccessoryView() else { return }
        self.accessoryView = view
        self.inputAccessoryView = view
        view.previousBtn.xAddClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.previousInput?.becomeFirstResponder()
        }
        view.nextBtn.xAddClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.nextInput?.becomeFirstResponder()
        }
        view.completedBtn.xAddClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.endEditing(true)
        }
    }
    /// 视图已显示（GCD调用）
    open func viewDidAppear() {
        
    }
    /// 自定义键盘扩展视图
    open func loadAccessoryView() -> xInputAccessoryView?
    {
        let view = xInputAccessoryView.loadNib()
        return view
    }
    
    // MARK: - Public Func
    /// 添加开始编辑回调
    public func addBeginEditHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.beginEditHandler = handler
    }
    /// 添加编辑中回调
    public func addEditingHandler(_ handler : @escaping xHandlerTextFieldInput)
    {
        self.editingHandler = handler
    }
    /// 添加结束编辑回调
    public func addEndEditHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.endEditHandler = handler
    }
    /// 添加return回调
    public func addReturnHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.returnHandler = handler
    }
    /// 设置内容
    public func reset(text : String?)
    {
        // 需要先解除事件监听
        self.removeTarget(self,
                          action: #selector(textChanged),
                          for: .editingChanged)
        self.text = text
        self.addTarget(self,
                       action: #selector(textChanged),
                       for: .editingChanged)
    }
    /// 关联输入框上下级
    public static func relateInput(list : [xTextField?])
    {
        let count = list.count
        guard count > 1 else { return }
        for i in 0 ..< count {
            guard let input = list[i] else { continue }
            let preIdx = i - 1
            let nexIdx = i + 1
            if preIdx >= 0 {
                input.previousInput = list[preIdx]
            }
            if nexIdx < count {
                input.nextInput = list[nexIdx]
            }
        }
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
            self.viewDidAppear()
        }
        
        self.isInitCompleted = true
        objc_sync_exit(self)
    }
    /// 内容变动
    @objc private func textChanged()
    {
        let str = self.text ?? ""
        if !self.isSecureTextEntry {
            self.accessoryView?.textLbl.text = str
        }
        self.editingHandler?(str)
    }

    // MARK: - UITextFieldDelegate
    /// 开始编辑
    open func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.accessoryView?.previousBtn.isEnabled = (self.previousInput != nil)
        self.accessoryView?.nextBtn.isEnabled = (self.nextInput != nil)
        self.beginEditHandler?()
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
    }
    /// 结束编辑
    open func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.endEditHandler?()
        self.accessoryView?.textLbl.text = nil
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
    }
    /// 编辑完成
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.returnHandler?()
        self.accessoryView?.textLbl.text = nil
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
        return true
    }
    /// 清空内容
    open func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    
}
