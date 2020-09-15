//
//  String+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import UIKit
import CommonCrypto

extension String {
    
    // MARK: - Enum
    /// 哈希算法类型枚举(长度不同)
    public enum xHashAlgorithmType
    {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        /// 其对应的摘要长度值
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
                case .MD5:      result = CC_MD5_DIGEST_LENGTH
                case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
                case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
                case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
                case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
                case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
        /// 散列使用的算法类型
        var hmacAlgorithm: CCHmacAlgorithm {
            var result: Int = 0
            switch self {
                case .MD5:      result = kCCHmacAlgMD5
                case .SHA1:     result = kCCHmacAlgSHA1
                case .SHA224:   result = kCCHmacAlgSHA224
                case .SHA256:   result = kCCHmacAlgSHA256
                case .SHA384:   result = kCCHmacAlgSHA384
                case .SHA512:   result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
    }
    
    // MARK: - Public Func
    // TODO: 哈希算法加密解密
    /// base64编码
    /// - Parameter options: 编码选项
    /// - Returns: 编码结果
    public func x_toBase64EncodingString(options : Data.Base64EncodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = self.data(using: .utf8)
        let ret = data?.base64EncodedString(options: options)
        return ret
    }
    
    /// base64解码
    /// - Parameter options: 解码选项
    /// - Returns: 解码结果
    public func x_toBase64DecodingString(options : Data.Base64DecodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = Data(base64Encoded: self, options: options)
        let ret = String(data: data!, encoding: .utf8)
        return ret
    }
    
    /// MD5加密
    /// - Parameter salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func x_toMD5String(salt : String = "") -> String
    {
        // 加密类型
        let type = xHashAlgorithmType.MD5
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        // 声明指针(地址)
        let cStr = str.cString(using: .utf8)
        // 声明长度(字节)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        // 结果缓存区
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 根据指定的类型进行加密
        CC_MD5(cStr, len, buffer)
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        // 释放内存
        free(buffer)
        return ret
    }
    
    /// SHA加密
    /// - Parameters:
    ///   - type: 加密算法类型，具体参考枚举内容
    ///   - salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func x_toSHAString(type : xHashAlgorithmType,
                              salt : String = "") -> String
    {
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        // 声明指针(地址)
        let cStr = str.cString(using: .utf8)
        // 声明长度(字节)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        // 结果缓存区
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 根据指定的类型进行加密
        switch type {
            case .SHA1:     CC_SHA1(cStr, len, buffer)
            case .SHA224:   CC_SHA224(cStr, len, buffer)
            case .SHA256:   CC_SHA256(cStr, len, buffer)
            case .SHA384:   CC_SHA384(cStr, len, buffer)
            case .SHA512:   CC_SHA512(cStr, len, buffer)
            default:    x_warning("加密算法类型有误,不是SHA")
        }
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        // 释放内存
        free(buffer)
        return ret
    }
    
    /// HMAC加密方案
    /// - Parameters:
    ///   - type:  加密算法类型，具体参考枚举内容
    ///   - key: 密钥
    /// - Returns: 加密后的字符串
    public func x_toHMACString(type : xHashAlgorithmType,
                               key : String) -> String
    {
        // 加密内容指针和长度
        let cStr = self.cString(using: .utf8)
        let len = Int(self.lengthOfBytes(using: .utf8))
        // 明文秘钥指针长度
        let cStrKey = key.cString(using: .utf8)
        let lenKey = Int(key.lengthOfBytes(using: .utf8))
        // 结果缓存区
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 加密
        CCHmac(type.hmacAlgorithm, cStrKey, lenKey, cStr, len, buffer)
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        // 释放内存
        free(buffer)
        return ret
    }
    
    // TODO: 字符串截取
    /// 截取指定范围字符串
    public func x_sub(range : NSRange) -> String?
    {
        let loc = range.location
        let len = range.length
        guard loc + len <= self.count else {
            x_warning("截取的长度超出字符串范围")
            return nil
        }
        guard loc >= 0, len >= 0 else {
            x_warning("截取参数不能为负数")
            return nil
        }
        let nsStr = self as NSString
        let ret = nsStr.substring(with: range)
        return ret
    }
    
    /// 替换指定范围字符串
    public func x_replace(range : NSRange,
                          to str : String) -> String?
    {
        let loc = range.location
        let len = range.length
        guard loc + len <= self.count else {
            x_warning("截取的长度超出字符串范围")
            return nil
        }
        guard loc >= 0, len >= 0 else {
            x_warning("截取参数不能为负数")
            return nil
        }
        let nsStr = self as NSString
        let ret = nsStr.replacingCharacters(in: range, with: str)
        return ret
    }
    
    /// 截取前几位字符串(截取失败返回空字符串)
    public func x_subPrefix(length : Int) -> String?
    {
        let range = NSMakeRange(0, length)
        let ret = self.x_sub(range: range)
        return ret
    }
    
    /// 截取后几位字符串(截取失败返回空字符串)
    public func x_subSuffix(length : Int) -> String?
    {
        let loc = self.count - length
        let range = NSMakeRange(loc, length)
        let ret = self.x_sub(range: range)
        return ret
    }
    
    // TODO: 类型转换
    /// 转换成Int类型数据
    public func x_toInt() -> Int
    {
        guard let ret = Int(self) else { return 0 }
        return ret
    }
    
    /// 转换成Float类型数据
    public func x_toFloat() -> Float
    {
        guard let ret = Float(self) else { return 0 }
        return ret
    }
    
    /// 转换成Double类型数据
    public func x_toDouble() -> Double
    {
        guard let ret = Double(self) else { return 0 }
        return ret
    }
    
    /// bool字符串
    public func x_toBool() -> Bool
    {
        let arr = ["", "0", "No", "NO", "False", "FALSE"]
        for str in arr {
            if str == self {
                return false
            }
        }
        return true
    }
    
    /// URL编码
    public func x_toUrlEncodeString() -> String?
    {
        let set = CharacterSet.urlQueryAllowed
        let ret = self.addingPercentEncoding(withAllowedCharacters: set)
        return ret
    }
    
    /// URL编码
    public func x_toUrlDecodeString() -> String?
    {
        let ret = self.removingPercentEncoding
        return ret
    }
    
    /// 转换成URL
    public func x_toURL() -> URL?
    {
        // 做url编码
        if let str = self.x_toUrlEncodeString() {
            let url = URL.init(string: str)
            return url
        }
        if let data = self.data(using: String.Encoding.utf8) {
            let url = URL.init(dataRepresentation: data,
                               relativeTo: nil)
            return url
        }
        return nil
    }
    
    /// 转换成UIImage类型数据
    public func x_toImage() -> UIImage?
    {
        guard let ret = UIImage.init(named: self) else {
            x_warning("找不到文件名为 \(self) 的图片")
            return nil
        }
        return ret
    }
    
    /// 转换成国际计数（三位分节法，每3位加一个","）
    public func x_toInternationalNumberString() -> String?
    {
        // 0没啥好转换的
        guard self.x_toDouble() != 0 else { return "0" }
        // 获取整数和小数位
        let arr = self.components(separatedBy: ".")
        var intStr = "\(arr.first!.x_toInt())"
        // 整数长度
        var len = intStr.count
        var ret : String = ""
        while (len > 3) {
            len -= 3
            let loc = intStr.count - 3
            let range1 = NSMakeRange(loc, 3)
            if let sub = intStr.x_sub(range: range1) {
                ret = "," + sub + ret
            }
            let range2 = NSMakeRange(0, loc)
            if let sub = intStr.x_sub(range: range2) {
                intStr = sub
            }
        }
        ret = intStr + ret
        // 补充小数
        if arr.count == 2 {
            let decimal = arr.last!
            ret += "." + decimal
        }
        return ret
    }
    
    /// 转换成日期格式
    /// - Parameters:
    ///   - format: 格式
    ///   - isMillisecond: 是否毫秒级
    public func x_toDateString(format : String,
                               isMillisecond : Bool = false) -> String
    {
        let fm = DateFormatter.init()
        fm.dateFormat = format
        var time = self.x_toDouble()
        if isMillisecond {
            time /= 1000
        }
        let date = Date.init(timeIntervalSince1970: time)
        let ret = fm.string(from: date)
        return ret
    }
    
    /// 字符串划线
    public func x_toLineString(color : UIColor = .lightGray) -> NSAttributedString
    {
        var dic = [NSAttributedString.Key : Any]()
        dic[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        dic[.strikethroughColor] = color
        dic[.baselineOffset] = 0
        let atr = NSAttributedString.init(string: self,
                                          attributes: dic)
        return atr
    }
    
    // TODO: 其他
    /// 获取首字母
    public func x_getFirstLetter() -> String
    {
        // 转变成可变字符串
        let mStr = NSMutableString.init(string: self)
        // 将中文转换成带声调的拼音
        CFStringTransform(mStr as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(变音不敏感)
        var pinyinStr = mStr.folding(options: .diacriticInsensitive, locale: .current)
        // 将拼音首字母换成大写
        pinyinStr = pinyinStr.uppercased()
        // 截取大写首字母
        let firstStr = String(pinyinStr.prefix(1))
        // 判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        let ret = predA.evaluate(with: firstStr) ? firstStr : "#"
        return ret
    }
    
    /// 判断字符串是否包含另外一个字符串
    /// - Parameters:
    ///   - find: 另外一个字符串
    ///   - isIgnoringCase: 是否忽视大小写
    /// - Returns: 判断结果
    public func x_contains(subStr : String,
                           isIgnoringCase : Bool = false) -> Bool
    {
        if isIgnoringCase {
            return self.range(of: subStr, options: .caseInsensitive) != nil
        }
        else {
            return self.range(of: subStr) != nil
        }
    }
}
