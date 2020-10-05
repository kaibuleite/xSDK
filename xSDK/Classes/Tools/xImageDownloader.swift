//
//  xImageDownloader.swift
//  xSDK
//
//  Created by Mac on 2020/10/5.
//

import UIKit
import SDWebImage

public class xImageDownloader: NSObject {
    
    // MARK: - Public Func
    /// 下载图片
    public static func download(url : String,
                                progress handler1 : @escaping SDWebImageDownloaderProgressBlock,
                                completed handler2 : @escaping SDWebImageDownloaderCompletedBlock)
    {
        let op1 = SDWebImageDownloaderOptions.highPriority
        let op2 = SDWebImageDownloaderOptions.scaleDownLargeImages
        let op3 = SDWebImageDownloaderOptions.avoidDecodeImage
        let options = SDWebImageDownloaderOptions.init(rawValue: op1.rawValue | op2.rawValue | op3.rawValue)
        SDWebImageDownloader.shared.downloadImage(with: url.xToURL(),
                                                  options: options,
                                                  progress: handler1,
                                                  completed: handler2)
        
    }
}
