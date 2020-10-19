//
//  xAppManager+Downloader.swift
//  xSDK
//
//  Created by Mac on 2020/10/14.
//

import UIKit
import SDWebImage

extension xAppManager {
    
    // MARK: - Public Func
    /// 下载图片
    /// - Parameters:
    ///   - url: 图片url
    ///   - handler1: 下载中回调
    ///   - handler2: 下载完成回调
    public static func download(url : String,
                                progress handler1 : @escaping SDWebImageDownloaderProgressBlock,
                                completed handler2 : @escaping SDWebImageDownloaderCompletedBlock)
    {
        let op1 = SDWebImageDownloaderOptions.highPriority
        let op2 = SDWebImageDownloaderOptions.scaleDownLargeImages
        let op3 = SDWebImageDownloaderOptions.avoidDecodeImage
        let options = SDWebImageDownloaderOptions.init(rawValue: op1.rawValue | op2.rawValue | op3.rawValue)
        /*
         下载中图片的加载
         let source = CGImageSourceCreateIncremental(nil) // 创建一个空的图片源，随后在获得新数据时调用
         CGImageSourceUpdateData(source, <#T##data: CFData##CFData#>, false) // 更新图片源
         CGImageSourceCreateImageAtIndex(source, 0, nil) // 创建图片
         */
        SDWebImageDownloader.shared.downloadImage(with: url.xToURL(),
                                                  options: options,
                                                  progress: handler1,
                                                  completed: handler2)
        
    }
    
    /// 从缓存中获取图片
    /// - Parameter key: 图片url
    /// - Returns: 图片
    public static func getSDCacheImage(forKey key: String) -> UIImage?
    {
        let mgr = SDImageCache.shared
        if let img = mgr.imageFromCache(forKey: key) { return img}
        if let img = mgr.imageFromMemoryCache(forKey: key) { return img }
        if let img = mgr.imageFromDiskCache(forKey: key) { return img }
        return nil
    }
}
