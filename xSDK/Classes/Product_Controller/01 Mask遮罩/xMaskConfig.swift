//
//  xMaskConfig.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

public class xMaskConfig: NSObject {
    
    // MARK: - Enum
    /// 遮罩背景样式
    public enum xBackgroundStyleEnum {
        /// 透明
        case clear
        /// 灰色
        case gray
    }
    /// 遮罩标识样式
    public enum xLoadingFlagStyleEnum {
        /// 系统菊花
        case indicator
        /// gif图片
        case gif
        /// 自定义CA动画
        case anime
    }
    /// 遮罩动画样式
    public enum xLoadingAnimeTypeEnum {
        /// 线条跳动
        case lineJump
        /// 吃豆人
        case eatBeans
        /// 六芒星1
        case magic1
        /// 六芒星2
        case magic2
    }

    // MARK: - Public Property
    /// 背景样式
    public var bgStyle = xBackgroundStyleEnum.clear
    /// 标识样式
    public var flagStyle = xLoadingFlagStyleEnum.indicator
    /// 背景样式
    public var animeStyle = xLoadingAnimeTypeEnum.lineJump
    
}
