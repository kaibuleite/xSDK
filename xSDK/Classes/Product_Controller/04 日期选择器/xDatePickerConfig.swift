//
//  xDatePickerConfig.swift
//  xSDK
//
//  Created by Mac on 2020/9/18.
//

import UIKit

public class xDatePickerConfig: NSObject {

    // MARK: - Public Property
    /// 最晚日期
    public var maxDate : Date?
    /// 最早日期
    public var minDate : Date?
    /// 日期模式
    public var model = UIDatePicker.Mode.date
}
