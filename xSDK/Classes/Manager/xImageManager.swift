//
//  xImageManager.swift
//  xSDK
//
//  Created by Mac on 2020/10/26.
//

import UIKit
import Photos
import AssetsLibrary
import SDWebImage

public class xImageManager: NSObject {
    
    // MARK: - Public Property
    /// 单例
    // public static let shared = xImageManager()
    // private override init() { }
    
    // MARK: - Public Func
    //判断是否授权
    public static func isAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .notDetermined:
            return true
        default:
            xMessageAlert.display(message: "未获得相册权限")
            return false
        }
    }
    // TODO: SD框架缓存
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
    
    // TODO: SD框架图片加载
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
    
    // TODO: 保存图片到相册
    public static func saveImageToAlbum(_ img: UIImage?,
                                        completed handler: ((Bool) -> Void)?)
    {
        let data = img?.sd_imageData()
        self.saveImageToAlbum(data, completed: handler)
    }
    public static func saveImageToAlbum(_ imgData: Data?,
                                        completed handler: ((Bool) -> Void)?)
    {
        xLog(">>>>>>>>>> 开始保存图片")
        guard self.isAuthorized() else {
            xLog(">>>>>>>>>> ❌未取得相册权限")
            return
        }
        guard let data = imgData else {
            xLog(">>>>>>>>>> ❌图片数据为nil")
            return
        }
        xLog(">>>>>>>>>> 获取图片类型")
        let format = NSData.sd_imageFormat(forImageData: data)
        guard format != .undefined else {
            xMessageAlert.display(message: "图片格式不正确")
            xLog(">>>>>>>>>> ❌图片类型未知")
            return
        }
        xLog(">>>>>>>>>> 图片类型 = " + format.xGetImageTypeName())
        PHPhotoLibrary.shared().performChanges {
            xLog(">>>>>>>>>> 开始保存图片")
            // let req = PHAssetChangeRequest.creationRequestForAsset(from: ret) // 无法保存gif，用子类来
            let req = PHAssetCreationRequest.forAsset()
            req.addResource(with: .photo, data: data, options: nil)
            if let ident = req.placeholderForCreatedAsset?.localIdentifier {
                xLog(">>>>>>>>>> 图片保存成功，唯一标识 = " + ident)
            }
            
        } completionHandler: {
            (isSuccess, error) in
            if let err = error {
                xWarning(err.localizedDescription)
            }
            xMessageAlert.display(message: isSuccess ? "保存成功" : "保存失败")
            handler?(isSuccess)
        }
    }
    
    /*
     方法过时，用上面的替换
    /// 保存GIF图片到相册
    /// - Parameter data: GIF图片数据
    public static func saveGifDataToPhotosAlbum(_ data : NSData,
                                                completed handler: @escaping (Bool) -> Void)
    {
        guard self.isAuthorized() else { return }
        let metadata = ["UTI": kCMMetadataBaseDataType_GIF]
        // 开始写数据
        let library = ALAssetsLibrary.init()
        library.writeImageData(toSavedPhotosAlbum: data as Data, metadata: metadata) {
            (assetURL, error) in
            if let err = error {
                xMessageAlert.display(message: "保存失败")
                xWarning(err.localizedDescription)
            }
            else {
                xMessageAlert.display(message: "保存成功")
            }
        }
    }
     */
    
    /*
     旧方法，不推荐
    /// 保存图片到相册
    /// - Parameter img: 图片
    public static func saveImageToPhotosAlbum(_ img: UIImage,
                                              completed handler: @escaping (Bool) -> Void)
    {
        guard self.isAuthorized() else { return }
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
     
     */
}

// MARK: - Ex SDImageFormat
extension SDImageFormat {
    
    /// 获取图片类型名称
    /// - Returns: 获取图片类型名称
    public func xGetImageTypeName() -> String
    {
        switch self {
        case .JPEG:     return "jpg" // jpeg
        case .PNG:      return "png"
        case .GIF:      return "gif"
        case .TIFF:     return "tiff" // tif
        case .webP:     return "webp"
        case .HEIC:     return "heic"
        case .HEIF:     return "heif"
        case .PDF:      return "pdf"
        case .SVG:      return "svg"
        default:        return "unknown"
        }
    }
}
