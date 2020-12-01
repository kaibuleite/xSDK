//
//  xKeychainManager.swift
//  xSDK
//
//  Created by Mac on 2020/11/20.
//

import UIKit

public class xKeychainManager: NSObject {
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xKeychainManager()
    private override init() { }
    
    /// 分组信息，一般用于管理一个开发者下的多个应用之间的数据（默认为空）
    public var group = ""
    /// 服务信息（默认使用应用bundle id）
    public var service = xAppManager.appBundleID
    
    // MARK: - Private Property
    /// 通用查询配置
    private var genericQuery : NSDictionary
    {
        let dict = NSMutableDictionary.init()
        dict[String(kSecClass)] = String(kSecClassGenericPassword)
        if self.group.count > 0 {
            dict[String(kSecAttrAccessGroup)] = self.group
        }
        dict[String(kSecAttrService)] = self.service
        return dict
    }
    
    // MARK: - Public Func
    /// 保存数据到钥匙串
    /// - Parameters:
    ///   - value: 要保存的数据
    ///   - key: 数据的Key
    ///   - service: 所在服务
    @discardableResult
    public func save(value data : Data,
                     forKey key : String) -> Bool
    {
        // 配置参数
        let dict = NSMutableDictionary.init(dictionary: self.genericQuery)
        dict[String(kSecAttrAccount)] = key
        dict[String(kSecValueData)] = data
        // 更新数据
        var result : AnyObject?
        let status = SecItemAdd(dict, &result)
        // 结果判断
        switch status {
        case errSecSuccess:
            xLog(">>>>>>>> Keychain保存成功✅")
            return true
        case errSecDuplicateItem:
            xLog(">>>>>>>> Keychain重复插入，进行更新操作🆚")
            return self.update(value: data,
                               forKey: key)
        default:
            xLog(">>>>>>>> Keychain保存失败❎:\(status)")
            return false
        }
    }
    
    /// 删除钥匙串中的数据
    /// - Parameters:
    ///   - key: 数据的Key
    ///   - service: 所在服务
    /// - Returns: 更新结果
    @discardableResult
    public func delete(valueForKey key : String) -> Bool
    {
        // 配置参数
        let dict = NSMutableDictionary.init(dictionary: self.genericQuery)
        dict[String(kSecAttrAccount)] = key
        // 删除数据
        let status = SecItemDelete(dict)
        // 结果判断
        switch status {
        case errSecSuccess:
            xLog(">>>>>>>> Keychain删除成功✅")
            return true
        default:
            xLog(">>>>>>>> Keychain删除失败❎:\(status)")
            return false
        }
    }
    
    /// 更新钥匙串中的数据
    /// - Parameters:
    ///   - data: 要更新的数据
    ///   - key: 数据的Key
    ///   - service: 所在服务
    /// - Returns: 更新结果
    @discardableResult
    public func update(value data : Data,
                       forKey key : String) -> Bool
    {
        // 配置参数
        let dict = NSMutableDictionary.init(dictionary: self.genericQuery)
        dict[String(kSecAttrAccount)] = key
        // 查找数据
        var result : AnyObject?
        let status = SecItemCopyMatching(dict, &result)
        // 判断结果
        switch status {
        case errSecSuccess:
            // 配置更新参数
            let updateDict = [String(kSecValueData) : data] as NSDictionary
            // 更新数据
            let updateStatus = SecItemUpdate(dict, updateDict)
            // 判断结果
            switch updateStatus {
            case errSecSuccess:
                xLog(">>>>>>>> Keychain更新成功✅")
                return true
            default:
                xLog(">>>>>>>> Keychain更新失败❎:\(status)")
                return false
            }
        default:
            xLog(">>>>>>>> Keychain没有找到\(key)对应的数据❎:\(status)")
            return false
        }
    }
    
    /// 从钥匙串中查找数据
    /// - Parameters:
    ///   - key: 数据的Key
    ///   - service: 所在服务
    /// - Returns: 查找结果
    public func query(valueForKey key : String) -> Data?
    {
        // 配置参数
        let dict = NSMutableDictionary.init(dictionary: self.genericQuery)
        dict[String(kSecAttrAccount)] = key
        dict[String(kSecReturnData)] = kCFBooleanTrue // 获取存储数据，返回Data
        //dict[String(kSecReturnAttributes)] = kCFBooleanTrue // 获取数据附加信息，返回CFDictionary
        // 查找数据
        var result : AnyObject?
        let status = SecItemCopyMatching(dict, &result)
        // 结果判断
        switch status {
        case errSecSuccess:
            if let data = result as? Data {
                xLog(">>>>>>>> Keychain查找成功✅")
                return data
            }
            xLog(">>>>>>>> Keychain查找的数据类型无法识别❎")
            return nil
        case errSecItemNotFound:
            xLog(">>>>>>>> Keychain没有找到\(key)对应的数据❎")
            return nil
        default:
            xLog(">>>>>>>> Keychain查找失败❎:\(status)")
            return nil
        }
    }
    
}
