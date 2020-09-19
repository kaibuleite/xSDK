//
//  xEANCodeImageView.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xEANCodeImageView: UIImageView {
    
    // MARK: - Public Func
    /// 生成一维码(条形码)
    /// - Parameters:
    ///   - code: 内容
    ///   - size: 大小
    /// - Returns: 生成的一维码(条形码)
    public func set(code : String)
    {
        // 创建图片滤镜
        guard let filter_img = CIFilter.init(name: "CICode128BarcodeGenerator") else {
            x_warning("条形码过滤器初始化失败")
            return
        }
        filter_img.setDefaults()
        let data = code.data(using: .utf8, allowLossyConversion: false)
        filter_img.setValue(data, forKey: "InputMessage")
        // 创建颜色滤镜,黑白色
        guard let filter_color = CIFilter(name: "CIFalseColor") else {
            x_warning("颜色过滤器初始化失败")
            return
        }
        filter_color.setDefaults()
        filter_color.setValue(filter_img.outputImage, forKey: "inputImage")
        filter_color.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        filter_color.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 数据验证
        guard let ciimage = filter_color.outputImage else {
            x_warning("条形码生成失败")
            return
        }
        let ret = UIImage.init(ciImage: ciimage)
        self.image = ret.x_scale(size: self.bounds.size)
    }

}
