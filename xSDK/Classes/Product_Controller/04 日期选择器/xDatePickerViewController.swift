//
//  xDatePickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

public class xDatePickerViewController: xPushAlertViewController {

    // MARK: - Handler
    /// 选择日期回调
    public typealias xHandlerChooseDate = (Double) -> Void

    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIDatePicker!
    
    // MARK: - Public Property
    /// 配置
    public var config = xDatePickerConfig()
    
    // MARK: - Private Property
    /// 回调
    private var chooseHandler : xHandlerChooseDate?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
    }
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xDatePickerViewController.new(storyboard: "xDatePickerViewController")
        return vc as! Self
    }
    
    // MARK: - IBAction Func
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        let date = self.picker.date
        let timeStamp = date.timeIntervalSince1970 
        self.chooseHandler?(timeStamp)
        self.dismiss()
    }
    
    // MARK: - Public Func
    /// 显示选择器
    /// - Parameters:
    ///   - title: 标题
    ///   - springDamping: 弹性阻尼，越小效果越明显
    ///   - springVelocity: 弹性修正速度，越大修正越快
    ///   - handler: 回调
    public func display(title : String,
                        date : Date = .init(),
                        isSpring : Bool = true,
                        choose handler : @escaping xHandlerChooseDate)
    {
        // 保存数据
        self.titleLbl.text = title
        self.picker.date = date
        self.chooseHandler = handler
        self.picker.maximumDate = config.maxDate
        self.picker.minimumDate = config.minDate
        self.picker.datePickerMode = config.model
        // 执行动画
        super.display(isSpring: isSpring)
    }
    
}
