//
//  xDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

public class xDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseData = ([xDataPickerModel]) -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Private Property
    /// 数据源
    private var dataArray = [[xDataPickerModel]]()
    /// 每一列选中的行
    private var columnChooseRowArray = [Int]()
    /// 回调
    private var handler : xHandlerChooseData?
    
    // MARK: - 内存释放
    deinit {
        self.handler = nil
        self.picker.dataSource = nil
        self.picker.delegate = nil
    }
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xDataPickerViewController.new(storyboard: "xDataPickerViewController")
        return vc as! Self
    }
    
    // MARK: - IBAction Func
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        var arr = [xDataPickerModel]()
        for (i, list) in self.dataArray.enumerated() {
            let row = self.columnChooseRowArray[i]
            let model = list[row]
            arr.append(model)
        }
        self.handler?(arr)
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
                        isSpring : Bool = true,
                        handler : @escaping xHandlerChooseData)
    {
        // 保存数据
        self.titleLbl.text = title
        self.handler = handler
        // 执行动画
        super.display(isSpring: isSpring)
    }
    /// 重新加载数据
    public func reload(dataArray : [[xDataPickerModel]])
    {
        guard dataArray.count > 0 else {
            x_warning("没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        // 重新加载
        self.dataArray = dataArray
        self.columnChooseRowArray = .init(repeating: 0, count: dataArray.count)
        self.picker.reloadAllComponents()
        // 重置状态
        for i in 0 ..< dataArray.count {
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    /// 几列
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return self.dataArray.count
    }
    /// 每列有几行
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        let list = self.dataArray[component]
        return list.count
    }
    /// 为指定的列和行赋值
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        let list = self.dataArray[component]
        let model = list[row]
        return model.name
    }
    
    // MARK: - UIPickerViewDelegate
    /// 选中某列某行
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int)
    {
        self.columnChooseRowArray[component] = row
    }
    
}
