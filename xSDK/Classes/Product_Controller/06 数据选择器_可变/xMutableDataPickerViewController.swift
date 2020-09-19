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
    public typealias xHandlerChooseMutableData = (xMutableDataPickerModel) -> Void
    
    // MARK: - IBOutlet Property
    /// 标题标签
    @IBOutlet weak var titleLbl: UILabel!
    /// 选择器
    @IBOutlet weak var picker: UIPickerView!
    
    // MARK: - Private Property
    /// 数据源
    private var dataArray = [xMutableDataPickerModel]()
    /// 每一列选中的行
    private var columnChooseRowArray = [Int]()
    /// 当前选中的数据
    var currentChooseDataModel = xMutableDataPickerModel()
    /// 列数
    private var column = 0
    /// 回调
    private var handler : xHandlerChooseMutableData?
    
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
        
        self.dismiss()
    }

    // MARK: - Public Func
    /// 重新加载数据
    public func reload(dataArray : [xMutableDataPickerModel])
    {
        self.dataArray = dataArray
        self.column = Int.max
        self.resetMinColumn(dataArray: dataArray)
        self.columnChooseRowArray = [Int].init(repeating: 0, count: self.column)
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.reloadAllComponents()
    }
    
    /// 显示选择器
    /// - Parameters:
    ///   - title: 标题
    ///   - springDamping: 弹性阻尼，越小效果越明显
    ///   - springVelocity: 弹性修正速度，越大修正越快
    ///   - handler: 回调
    public func display(title : String,
                        isSpring : Bool = true,
                        handler : @escaping xHandlerChooseMutableData)
    {
        // 保存数据
        self.titleLbl.text = title
        self.handler = handler
        // 执行动画
        super.display(isSpring: isSpring)
    }

    // MARK: - Private Func
    /// 获取最短列
    private func resetMinColumn(dataArray : [xMutableDataPickerModel])
    {
        for data in dataArray {
            // 子集不为空，继续遍历
            if data.childList.count > 0 {
                self.resetMinColumn(dataArray: data.childList)
                continue
            }
            // 子集为空，计算层级
            let column = data.layer + 1  // 层级从0开始算
            guard column < self.column else { continue }
            self.column = column
            x_log(data.layer, data.name)
            x_log("当前最少\(self.column)列")
        }
    }
    /// 获取该列的数据
    private func getDataArray(with column : Int) -> [xMutableDataPickerModel]
    {
        var ret = [xMutableDataPickerModel]()
        guard column < self.column else { return ret }
        if column == 0 {
            return self.dataArray
        }
        // 根据每列选中的Row来获取Data
        var chooseModel : xMutableDataPickerModel!
        for (i, row) in self.columnChooseRowArray.enumerated() {
            guard i < column else { break }
            if i == 0 {
                chooseModel = self.dataArray[row]
            } else {
                // 抽取子级内的数据
                chooseModel = chooseModel.childList[row]
            }
            ret = chooseModel.childList
        }
        return ret
    }
    
    // MARK: - UIPickerViewDataSource
    /// 几列
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return self.column
    }
    /// 每列有几行
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int
    {
        let list = self.getDataArray(with: component)
        return list.count
    }
    /// 为指定的列和行赋值
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String?
    {
        let list = self.getDataArray(with: component)
        let model = list[row]
        let title = model.name
        return title
    }
    
    // MARK: - UIPickerViewDelegate
    /// 选中某列某行
    public func pickerView(_ pickerView: UIPickerView,
                           didSelectRow row: Int,
                           inComponent component: Int)
    {
        // 重新加载数据
        self.columnChooseRowArray[component] = row
        for column in 0 ..< self.column {
            if column < component {
                // 左边的列，保持原样
            }
            else
            if column == component {
                // 选中的列，更新数据
                pickerView.reloadComponent(column)
            }
            else {
                // 右边的列，恢复到选中第一个数据
                self.columnChooseRowArray[column] = 0
                pickerView.selectRow(0, inComponent: column, animated: false)
                if column == self.column - 1 {
                    // 最后一列，获取选中的数据
                    let list = self.getDataArray(with: column)
                    let model = list[row]
                    let title = model.name
                    self.currentChooseDataModel = model
                    x_log(title)
                }
            }
        }
    }
    
}
