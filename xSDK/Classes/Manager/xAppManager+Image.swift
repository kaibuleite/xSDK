//
//  xAppManager+Image.swift
//  xSDK
//
//  Created by Mac on 2020/10/22.
//

import UIKit
import Photos
import SDWebImage

extension xAppManager {
    
    // MARK: - Public Func
    /// SD框架图片缓存大小
    /// - Returns: 缓存大小
    public static func getSDWebImageCacheSize() -> CGFloat
    {
        let size = SDImageCache.shared.totalDiskSize()
        // 换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
        let mb : CGFloat = CGFloat(size) / 1000 / 1000
        return mb
    }
    
    /// 清理SD框架图片缓存
    /// - Parameter handler: 清理完成回调
    public static func clearSDWebImageCache(completed handler : @escaping () -> Void)
    {
        SDImageCache.shared.clear(with: .all) {
            xLog("清理完成")
            handler()
        }
    }
    
    /// 下载图片
    /// - Parameters:
    ///   - url: 图片url
    ///   - handler1: 下载中回调
    ///   - handler2: 下载完成回调
    public static func downloadImage(url : String,
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
        // 从缓存里找
        if let img = mgr.imageFromCache(forKey: key) { return img}
        // 从内存里找
        if let img = mgr.imageFromMemoryCache(forKey: key) { return img }
        // 从磁盘里找
        if let img = mgr.imageFromDiskCache(forKey: key) { return img }
        // 找不到
        return nil
    }
    
    /// 保存图片到相册(支持gif，apng)
    /// - Parameter img: 图片
    public static func saveImageToPHPhotoLibraryAlbum(_ img: UIImage,
                                                      completed handler: @escaping (Bool, Error?) -> Void)
    {
        guard self.isAuthorized() else {
            xMessageAlert.display(message: "请到设置中开放相册权限")
            return
        }
        let library = PHPhotoLibrary.shared()
        library.performChanges {
            let req = PHAssetChangeRequest.creationRequestForAsset(from: img)
            if let asset = req.placeholderForCreatedAsset {
                xLog("唯一标识 = \(asset.localIdentifier)")
            }
            
        } completionHandler: {
            (finish, error) in
            if let err = error {
                xMessageAlert.display(message: "保存失败")
                xWarning(err.localizedDescription)
            }
            else {
                xMessageAlert.display(message: "保存成功")
            }
            handler(finish, error)
        }
    }
    
    /// 保存图片到相册
    /// - Parameter img: 图片
    public static func saveImageToPhotosAlbum(_ img: UIImage)
    {
        guard self.isAuthorized() else {
            xMessageAlert.display(message: "请到设置中开放相册权限")
            return
        }
        UIImageWriteToSavedPhotosAlbum(img, shared, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - Private Func
    /// 保存图片到相册回调
    /// - Parameters:
    ///   - image: 图片
    ///   - error: 错误
    ///   - contextInfo: 上下文信息
    @objc private func saveImage(image: UIImage,
                                 didFinishSavingWithError error: NSError?,
                                 contextInfo: AnyObject)
    {
        if let err = error {
            xMessageAlert.display(message: "保存失败")
            xWarning(err.localizedDescription)
        }
        else {
            xMessageAlert.display(message: "保存成功")
        }
    }
    
    //判断是否授权
    private static func isAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .notDetermined:
            return true
        default:
            return false
        }
    }
}
