//
//  xMutableDataPickerViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xMutableDataPickerViewController: xPushAlertViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Handler
    /// 选择数据回调
    public typealias xHandlerChooseMutableData = ([xMutableDataPickerModel]) -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Private Property
    /// 数据源
    private var dataArray = [[xMutableDataPickerModel]]()
    /// 所有数据源
    private var totalDataArray = [xMutableDataPickerModel]()
    /// 每一列选中的行
    private var columnChooseRowArray = [Int]()
    /// 最短数据长度
    private var minDataLength = Int.max
    /// 最长数据长度
    private var maxDataLength = Int.zero
    /// 回调
    private var chooseHandler : xHandlerChooseMutableData?
    
    // MARK: - 内存释放
    deinit {
        self.chooseHandler = nil
        self.picker.dataSource = nil
        self.picker.delegate = nil
    }
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xMutableDataPickerViewController.xNew(storyboard: "xMutableDataPickerViewController")
        return vc as! Self
    }
    
    // MARK: - IBAction Func
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        var arr = [xMutableDataPickerModel]()
        for (i, list) in self.dataArray.enumerated() {
            let row = self.columnChooseRowArray[i]
            let model = list[row]
            arr.append(model)
        }
        self.chooseHandler?(arr)
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
                        choose handler : @escaping xHandlerChooseMutableData)
    {
        // 保存数据
        self.titleLbl.text = title
        self.chooseHandler = handler
        // 执行动画
        super.display(isSpring: isSpring)
    }
    /// 重新加载数据
    public func reload(dataArray : [xMutableDataPickerModel])
    {
        guard dataArray.count > 0 else {
            xWarning("没有数据，不加载")
            return
        }
        self.picker.dataSource = self
        self.picker.delegate = self
        // 清空数据
        self.minDataLength = Int.max
        self.maxDataLength = Int.zero
        self.totalDataArray.removeAll()
        // 数据预处理
        for (i, model) in dataArray.enumerated() {
            model.column = 0
            model.row = i
        }
        // 重新加载
        self.forEach(dataArray: dataArray)
        if self.minDataLength != self.maxDataLength {
            xWarning("数据长度不一致，[\(self.minDataLength), \(self.maxDataLength)]")
        }
        /*
        self.totalDataArray.forEach {
            (model) in
            xLog("\(model.rowNumber) \(model.name)")
        }*/
        self.columnChooseRowArray = .init(repeating: 0, count: self.minDataLength)
        self.updateDataArray()
        self.picker.reloadAllComponents()
        // 重置状态
        for i in 0 ..< self.minDataLength {
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
    }

    // MARK: - Private Func
    /// 遍历数据
    private func forEach(dataArray : [xMutableDataPickerModel])
    {
        for model in dataArray {
            self.totalDataArray.append(model)
            // 子集不为空，继续遍历
            if model.childList.count > 0 {
                self.forEach(dataArray: model.childList)
                continue
            }
            // 子集为空，计算数据长度
            let column = model.column + 1  // 技术从0开始算
            if column > self.maxDataLength {
                self.maxDataLength = column
                xLog("数据最长列更新为\(column) - \(model.name)")
            }
            if column < self.minDataLength {
                self.minDataLength = column
                xLog("数据最短列更新为\(column) - \(model.name)")
            }
        }
    }
    /// 更新数据源
    public func updateDataArray()
    {
        var ret = [[xMutableDataPickerModel]].init(repeating: .init(),
                                                   count: self.minDataLength)
        for column in 0 ..< self.minDataLength {
            // 获取行编号
            var rowNumber = ""
            for (i, row) in self.columnChooseRowArray.enumerated() {
                guard i < column else { continue }
                rowNumber += "\(row)"
            }
            // 筛选数据
            for model in self.totalDataArray {
                // 同列的数据
                guard column == model.column else { continue }
                if model.rowNumber.hasPrefix(rowNumber) {
                    ret[column].append(model)
                }
            }
        }
        self.dataArray = ret
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
        // 重新加载数据
        self.columnChooseRowArray[component] = row
        // 重置状态
        for i in component + 1 ..< self.minDataLength {
            self.columnChooseRowArray[i] = 0
            self.picker.selectRow(0, inComponent: i, animated: false)
        }
        // 加载数据
        self.updateDataArray()
        for i in component + 1 ..< self.minDataLength {
            self.picker.reloadComponent(i)
        }
    }
    
}
