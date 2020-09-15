//
//  xTextField.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

class xTextField: UITextField, UITextFieldDelegate {

    /// 输入框内容回调
    public typealias xHandlerTextFieldInput = (String) -> Void
    public typealias xHandlerTextFieldChangeStatus = () -> Void
    
    // MARK: - Public Property
    /// 容器
    @IBInspectable public var container : UIView?
    /// 容器边框默认颜色
    @IBInspectable public var containerBoardNomalColor : UIColor = .x_hex("E5E5E5")
    /// 边框选中颜色
    @IBInspectable public var containerBoardSelectedColor : UIColor = .x_hex("EB0A1E")
    /// 上一个输入框
    public weak var previousInput : xTextField?
    /// 下一个输入框
    public weak var nextInput : xTextField?
    
    // MARK: - Private Property
    /// 自定义键盘扩展视图
    private var accessoryView : xInputAccessoryView?
    /// 开始编辑回调
    private var handler_beginEdit : xHandlerTextFieldChangeStatus?
    /// 编辑中回调
    private var handler_editing : xHandlerTextFieldInput?
    /// 编辑结束回调
    private var handler_endEdit : xHandlerTextFieldChangeStatus?
    /// return按钮回调
    private var handler_return : xHandlerTextFieldChangeStatus?
    
    // MARK: - 内存释放
    deinit {
        self.handler_beginEdit = nil
        self.handler_editing = nil
        self.handler_endEdit = nil
        self.handler_return = nil
        self.previousInput = nil
        self.nextInput = nil
    }
    
    // MARK: - 视图加载
    override func awakeFromNib() {
        super.awakeFromNib()
        // 或者在 init(coder:) 里实现
        self.setContentKit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentKit()
    }
    
    // MARK: - 方法调用
    /// 添加开始编辑回调
    public func addBeginEditHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.handler_beginEdit = handler
    }
    /// 添加编辑中回调
    public func addEditingHandler(_ handler : @escaping xHandlerTextFieldInput)
    {
        self.handler_editing = handler
    }
    /// 添加结束编辑回调
    public func addEndEditHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.handler_endEdit = handler
    }
    /// 添加return回调
    public func addReturnHandler(_ handler : @escaping xHandlerTextFieldChangeStatus)
    {
        self.handler_return = handler
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
    
    // MARK: - 方法重写
    /// 自定义键盘扩展视图
    open func loadAccessoryView() -> xInputAccessoryView?
    {
        let view = xInputAccessoryView.loadNib()
        return view
    }
    
    // MARK: - 内部调用
    /// 设置内容UI
    private func setContentKit()
    {
        // 最小缩放系数(对单行的label才有效果)
        self.minimumFontSize = 0.5
        self.adjustsFontSizeToFitWidth = true
        self.delegate = self
        // 编辑事件
        self.addTarget(self, action: #selector(textChanged),
                       for: .editingChanged)
        // 附加菜单事件
        guard let view = self.loadAccessoryView() else { return }
        self.accessoryView = view
        self.inputAccessoryView = view
        view.previousBtn.x_addClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.previousInput?.becomeFirstResponder()
        }
        view.nextBtn.x_addClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.nextInput?.becomeFirstResponder()
        }
        view.completedBtn.x_addClick {
            [weak self] (sender) in
            guard let ws = self else { return }
            ws.endEditing(true)
        }
    }
    /// 内容变动
    @objc private func textChanged()
    {
        let str = self.text ?? ""
        if !self.isSecureTextEntry {
            self.accessoryView?.textLbl.text = str
        }
        self.handler_editing?(str)
    }

    // MARK: - UITextFieldDelegate
    /// 开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.accessoryView?.previousBtn.isEnabled = (self.previousInput != nil)
        self.accessoryView?.nextBtn.isEnabled = (self.nextInput != nil)
        self.handler_beginEdit?()
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
    }
    /// 结束编辑
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.handler_endEdit?()
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
    }
    /// 编辑完成
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.handler_return?()
        // 修改容器边框
        if let container = self.container {
            container.layer.borderColor = self.containerBoardNomalColor.cgColor
        }
        return true
    }
    /// 清空内容
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }
    
}
