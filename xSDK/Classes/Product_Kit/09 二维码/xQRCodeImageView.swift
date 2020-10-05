//
//  xQRCodeImageView.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit

public class xQRCodeImageView: xImageView {
    
    // MARK: - Public Func
    /// 生成一维码(条形码)
    /// - Parameters:
    ///   - code: 内容
    ///   - size: 大小
    ///   - centerImage: 中心图片
    /// - Returns: 生成的一维码(条形码)
    public func set(code : String,
                    centerImage : UIImage? = nil)
    {
        let data = code.data(using: String.Encoding.utf8, allowLossyConversion: false)
        // 创建图片滤镜、设置二维码的精度(L M Q H)
        guard let filter_img = CIFilter.init(name: "CIQRCodeGenerator") else {
            xWarning("条形码过滤器初始化失败")
            return
        }
        filter_img.setDefaults()
        filter_img.setValue(data, forKey: "InputMessage")
        filter_img.setValue("H", forKey: "InputCorrectionLevel")    // 容错率
        // 创建颜色滤镜,黑白色
        guard let filter_color = CIFilter(name: "CIFalseColor") else {
            xWarning("颜色过滤器初始化失败")
            return
        }
        filter_color.setDefaults()
        filter_color.setValue(filter_img.outputImage, forKey: "inputImage")
        filter_color.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        filter_color.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 数据验证
        guard let ciimage = filter_color.outputImage else {
            xWarning("二维码生成失败")
            return
        }
        var ret : UIImage? = UIImage.init(ciImage: ciimage)
        if let centerImg = centerImage {
            ret = ret?.xToCoverCenter(image: centerImg)
        }
        self.image = ret?.xToScale(size: self.bounds.size)
    }

}
