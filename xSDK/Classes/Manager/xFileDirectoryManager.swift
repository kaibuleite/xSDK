//
//  xFileDirectoryManager.swift
//  xSDK
//
//  Created by Mac on 2020/10/26.
//

import UIKit

public class xFileDirectoryManager: NSObject {
    
    // MARK: - Public Func
    /// App Documents 文件夹目录
    public static func getDocumentsURL() -> URL?
    {
        let mgr = FileManager.default
        let ret = mgr.urls(for: .documentDirectory, in: .userDomainMask).last
        return ret
    }
    /// App Documents 文件夹目录
    public static func getDocumentsPath() -> String?
    {
        let ret = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return ret
    }
    /// App Caches 文件夹目录
    public static func getCachesURL() -> URL?
    {
        let mgr = FileManager.default
        let ret = mgr.urls(for: .cachesDirectory, in: .userDomainMask).last
        return ret
    }
    /// App Caches 文件夹目录
    public static func getCachesPath() -> String?
    {
        let ret = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        return ret
    }
    /// App library 文件夹目录
    public static func getLibraryURL() -> URL?
    {
        let mgr = FileManager.default
        let ret = mgr.urls(for: .libraryDirectory, in: .userDomainMask).last
        return ret
    }
    /// App library 文件夹目录
    public static func getLibraryPath() -> String?
    {
        let ret = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
        return ret
    }

}
