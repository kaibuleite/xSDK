//
//  String+xExtension.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/14.
//

import Foundation
import CommonCrypto

extension String {
    
    // MARK: - Enum
    /// 哈希算法类型枚举(长度不同)
    public enum xSHAAlgorithmType
    {
        case SHA1, SHA224, SHA256, SHA384, SHA512
        /// 其对应的摘要长度值
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
            case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    /// Hmac加密
    public enum xHMACAlgorithmType
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
    
    // MARK: - Public Property
    /// 首字母
    public var xFirstLetter : String
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
    
    // MARK: - Public Func
    // TODO: 哈希算法加密解密
    /// base64编码
    /// - Parameter options: 编码选项
    /// - Returns: 编码结果
    public func xToBase64EncodingString(options : Data.Base64EncodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = self.data(using: .utf8)
        let ret = data?.base64EncodedString(options: options)
        return ret
    }
    
    /// base64解码
    /// - Parameter options: 解码选项
    /// - Returns: 解码结果
    public func xToBase64DecodingString(options : Data.Base64DecodingOptions = .init(rawValue: 0)) -> String?
    {
        let data = Data(base64Encoded: self, options: options)
        let ret = String(data: data!, encoding: .utf8)
        return ret
    }
    
    /// MD5加密
    /// - Parameter salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func xToMD5String(salt : String = "") -> String
    {
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        let cStr = str.cString(using: .utf8)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        CC_MD5(cStr, len, buffer)
        // 解析结果
        var ret = ""
        for i in 0 ..< length {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        free(buffer)
        return ret
    }
    
    /// SHA加密
    /// - Parameters:
    ///   - type: 加密算法类型，具体参考枚举内容
    ///   - salt: 加盐字符串，默认为空字符串
    /// - Returns: 加密后的字符串
    public func xToSHAString(type : xSHAAlgorithmType,
                             salt : String = "") -> String
    {
        // 加盐处理后的字符串
        let str = String(format: "%@%@", self, salt)
        let cStr = str.cString(using: .utf8)
        let len = CC_LONG(str.lengthOfBytes(using: .utf8))
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: type.digestLength)
        // 根据指定的类型进行加密
        switch type {
            case .SHA1:     CC_SHA1(cStr, len, buffer)
            case .SHA224:   CC_SHA224(cStr, len, buffer)
            case .SHA256:   CC_SHA256(cStr, len, buffer)
            case .SHA384:   CC_SHA384(cStr, len, buffer)
            case .SHA512:   CC_SHA512(cStr, len, buffer)
        }
        // 解析结果
        var ret = ""
        for i in 0 ..< type.digestLength {
            let str = String(format: "%02x", buffer[i])
            ret.append(str)
        }
        free(buffer)
        return ret
    }
    
    /// HMAC加密方案
    /// - Parameters:
    ///   - type:  加密算法类型，具体参考枚举内容
    ///   - key: 密钥
    /// - Returns: 加密后的字符串
    public func xToHMACString(type : xHMACAlgorithmType,
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
    
    // TODO: 类型转换
    /// 转换成Int类型数据
    public func xToInt() -> Int
    {
        guard let ret = Int(self) else { return 0 }
        return ret
    }
    
    /// 转换成Float类型数据
    public func xToFloat() -> Float
    {
        guard let ret = Float(self) else { return 0 }
        return ret
    }
    
    /// 转换成Double类型数据
    public func xToDouble() -> Double
    {
        guard let ret = Double(self) else { return 0 }
        return ret
    }
    
    /// 转换成bool类型数据
    public func xToBool() -> Bool
    {
        let arr = ["", "0", "No", "NO", "False", "FALSE"]
        for str in arr {
            if str == self {
                return false
            }
        }
        return true
    }
    
    /// 转换成UIImage类型数据
    public func xToImage() -> UIImage?
    {
        guard let ret = UIImage.init(named: self) else {
            xWarning("找不到文件名为 \(self) 的图片")
            return nil
        }
        return ret
    }
    
    /// 转换成URL
    /// - Parameter isUsingUrlEncode: 是否使用URL编码
    /// - Returns: URL
    public func xToURL(isUsingUrlEncode: Bool = false) -> URL?
    {
        // 做url编码
        if isUsingUrlEncode {
            if let str = self.xToUrlEncodeString() {
                let url = URL.init(string: str)
                return url
            }
        }
        let url = URL.init(string: self)
        return url
    }
    
    // TODO: 格式转换
    /// UTF-8编码
    public func xUTF8String() -> String?
    {
        guard let data = self.data(using: .utf8) else { return nil }
        let ret = String.init(data: data, encoding: .utf8)
        return ret
    }
    /// URL编码
    public func xToUrlEncodeString() -> String?
    {
        let set = CharacterSet.urlQueryAllowed
        let ret = self.addingPercentEncoding(withAllowedCharacters: set)
        return ret
    }
    
    /// URL编码
    public func xToUrlDecodeString() -> String?
    {
        let ret = self.removingPercentEncoding
        return ret
    }
    
    /// 转换成国际计数（三位分节法，每3位加一个","）
    public func xToInternationalNumberString() -> String?
    {
        // 0没啥好转换的
        let str = self.replacingOccurrences(of: ",", with: "")
        guard str.xToDouble() != 0 else { return "0" }
        // 获取整数和小数位
        let arr = str.components(separatedBy: ".")
        var intStr = "\(arr.first!.xToInt())"
        // 整数长度
        var len = intStr.count
        var ret : String = ""
        while (len > 3) {
            len -= 3
            let loc = intStr.count - 3
            let range1 = NSMakeRange(loc, 3)
            if let sub = intStr.xSub(range: range1) {
                ret = "," + sub + ret
            }
            let range2 = NSMakeRange(0, loc)
            if let sub = intStr.xSub(range: range2) {
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
    public func xToDateString(format : String,
                               isMillisecond : Bool = false) -> String
    {
        let fm = DateFormatter.init()
        fm.dateFormat = format
        var time = self.xToDouble()
        if isMillisecond {
            time /= 1000
        }
        let date = Date.init(timeIntervalSince1970: time)
        let ret = fm.string(from: date)
        return ret
    }
    
    /// 字符串划线
    public func xToLineString(color : UIColor = .lightGray) -> NSAttributedString
    {
        var dic = [NSAttributedString.Key : Any]()
        dic[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        dic[.strikethroughColor] = color
        dic[.baselineOffset] = 0
        let atr = NSAttributedString.init(string: self,
                                          attributes: dic)
        return atr
    }
    
    // TODO: 字符串截取
    /// 截取指定范围字符串
    public func xSub(range : NSRange) -> String?
    {
        let loc = range.location
        let len = range.length
        guard loc + len <= self.count else {
            xWarning("截取的长度超出字符串范围")
            return nil
        }
        guard loc >= 0, len >= 0 else {
            xWarning("截取参数不能为负数")
            return nil
        }
        let nsStr = self as NSString
        let ret = nsStr.substring(with: range)
        return ret
    }
    
    /// 截取前几位字符串(截取失败返回空字符串)
    public func xSubPrefix(length : Int) -> String?
    {
        let range = NSMakeRange(0, length)
        let ret = self.xSub(range: range)
        return ret
    }
    
    /// 截取后几位字符串(截取失败返回空字符串)
    public func xSubSuffix(length : Int) -> String?
    {
        let loc = self.count - length
        let range = NSMakeRange(loc, length)
        let ret = self.xSub(range: range)
        return ret
    }
    
    /// 判断字符串是否包含另外一个字符串
    /// - Parameters:
    ///   - find: 另外一个字符串
    ///   - isIgnoringCase: 是否忽视大小写
    /// - Returns: 判断结果
    public func xContains(subStr : String,
                          isIgnoringCase : Bool = false) -> Bool
    {
        if isIgnoringCase {
            return self.range(of: subStr, options: .caseInsensitive) != nil
        }
        else {
            return self.range(of: subStr) != nil
        }
    }
    
    // TODO: 内容尺寸
    /// 获取内容尺寸
    /// - Parameters:
    ///   - font: 字体信息
    ///   - size: 限制尺寸
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 内容尺寸
    public func xGetSize(for font : UIFont,
                         size : CGSize,
                         lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGSize
    {
        /*
         换行模式说明 参考 https://www.jianshu.com/p/a794824d5513
         case byWordWrapping = 0    // 单词换行，每一行都末尾都显示完整的单词，显示不全换行，末尾不显示...
         case byCharWrapping = 1    // 字符换行，前几行不保证单词完整，最后一行显示不全直接省略，末尾不显示...
         case byClipping = 2        // 裁剪，前几行保证完整的单词，显示不全换行，最后一行末尾是按字符省略，末尾不显示...
         case byTruncatingHead = 3      // 头部省略，最后一行显示不全在前面加...
         case byTruncatingTail = 4      // 尾部省略，最后一行显示不全在后面加...
         case byTruncatingMiddle = 5    // 中间省略，最后一行显示不全在中间加...
         */
        let nsstr = self as NSString
        var attr = [NSAttributedString.Key : Any]()
        attr[.font] = font
        if lineBreakMode == .byWordWrapping {
            /*
             边框样式 参考 https://www.jianshu.com/p/c70dd08b90ac
             */
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineBreakMode = lineBreakMode
            attr[.paragraphStyle] = paragraphStyle
        }
        /*
         附加选项 参考 https://www.jianshu.com/p/e3dde269adc7
         UsesLineFragmentOrigin     // 以组成的矩形为单位计算整个文本的尺寸
         TruncatesLastVisibleLine   //以每个字或字形为单位来计算
         UsesDeviceMetric   // 以每个字或字形为单位来计算
         UsesFontLeading    // 以字体间的行距（leading，行距：从一行文字的底部到另一行文字底部的间距。）来计算
         */
        let op1 = NSStringDrawingOptions.usesLineFragmentOrigin
        let op2 = NSStringDrawingOptions.usesFontLeading
        let options = NSStringDrawingOptions.init(rawValue: op1.rawValue | op2.rawValue)
        let rect = nsstr.boundingRect(with: size,
                                      options: options,
                                      attributes: attr,
                                      context: nil)
        let ret = rect.size
        return ret;
    }
    
    /// 根据指定高度获取内容宽度(无限制)
    /// - Parameters:
    ///   - font: 字体信息
    ///   - height: 根据指定高度
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 内容尺寸
    public func xGetWidth(for font : UIFont,
                          height : CGFloat,
                          lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGFloat
    {
        let size = self.xGetSize(for: font,
                                 size: .init(width: CGFloat(MAXFLOAT),
                                             height: height),
                                 lineBreakMode: lineBreakMode)
        return size.width
    }
    /// 根据指定宽度获取内容高度(无限制)
    /// - Parameters:
    ///   - font: 字体信息
    ///   - width: 根据指定宽度
    ///   - lineBreakMode: 换行模式(内容显示不完全时的省略方式)
    /// - Returns: 内容尺寸
    public func xGetHeight(for font : UIFont,
                           width : CGFloat,
                           lineBreakMode: NSLineBreakMode = .byCharWrapping) -> CGFloat
    {
        let size = self.xGetSize(for: font,
                                 size: .init(width: width,
                                             height: CGFloat(MAXFLOAT)),
                                 lineBreakMode: lineBreakMode)
        return size.height
    }
    
    // TODO: 正则
    /// 判断是否满足正则表达式
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项
    /// - Returns: 结果
    public func xCheckRegex(pattern : String,
                            options : NSRegularExpression.Options = .caseInsensitive) -> Bool
    {
        /*
         附加选项 参考 https://www.jianshu.com/p/ec6339cc33ad
         NSRegularExpressionCaseInsensitive            // 不区分字母大小写的模式，aBc 会匹配到abc.
         NSRegularExpressionAllowCommentsAndWhitespace // 忽略掉正则表达式中的空格和#号之后的字符，表达式[a-z]，会匹配到[a-z]
         NSRegularExpressionIgnoreMetacharacters       // 将正则表达式整体作为字符串处理。表达式 a b c 会匹配到abc，ab#c会匹配到ab。
         NSRegularExpressionDotMatchesLineSeparators   // 允许.匹配任何字符，包括换行符
         NSRegularExpressionAnchorsMatchLines          // 允许^和$符号匹配行的开头和结尾
         NSRegularExpressionUseUnixLineSeparators      // 设置\n为唯一的行分隔符，否则所有的都有效。
         NSRegularExpressionUseUnicodeWordBoundaries   // 使用Unicode TR#29标准作为词的边界，否则所有传统正则表达式的词边界都有效

         NSMatchingReportProgress           // 找到最长的匹配字符串后调用block回调
         NSMatchingReportCompletion         // 找到任何一个匹配串后都回调一次block
         NSMatchingAnchored                 // 从匹配范围的开始出进行极限匹配
         NSMatchingWithTransparentBounds    // 允许匹配的范围超出设置的范围
         NSMatchingWithoutAnchoringBounds   // 禁止^和$自动匹配行还是和结束
         */
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return false }
        // 开始匹配
        let range = NSMakeRange(0, self.count)
        let ret = regex.numberOfMatches(in: self, options: .reportProgress, range: range)
        return ret > 0
    }
    
    /// 枚举正则结果
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项
    ///   - handler: 匹配回调
    public func xEnumerateRegexMatches(pattern : String,
                                       options : NSRegularExpression.Options = .caseInsensitive,
                                       handler : @escaping (String, NSRange) -> Void)
    {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return }
        let range = NSMakeRange(0, self.count)
        regex.enumerateMatches(in: self, options: .reportProgress, range: range) {
            (result, flags, stop) in
            let range = result?.range ?? .init(location: 0, length: 0)
            let str = self.xSub(range: range) ?? ""
            handler(str, range)
        }
    }
    
    // MARK: 字符串替换
    /// 替换指定范围字符串
    /// - Parameters:
    ///   - range: 范围
    ///   - str: 要替换的字符串
    /// - Returns: 结果
    public func xReplace(range : NSRange,
                         with str : String) -> String?
    {
        let loc = range.location
        let len = range.length
        guard loc + len <= self.count else {
            xWarning("截取的长度超出字符串范围")
            return nil
        }
        guard loc >= 0, len >= 0 else {
            xWarning("截取参数不能为负数")
            return nil
        }
        let nsStr = self as NSString
        let ret = nsStr.replacingCharacters(in: range, with: str)
        return ret
    }
    
    /// 用正则表达式替换字符串
    /// - Parameters:
    ///   - pattern: 规则
    ///   - options: 附加选项
    ///   - str: 要替换的字符串
    /// - Returns: 结果
    public func xReplaceRegex(pattern : String,
                              options : NSRegularExpression.Options = .caseInsensitive,
                              with str : String) -> String?
    {
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: options) else { return nil }
        let range = NSMakeRange(0, self.count)
        let ret = regex.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: str)
        return ret
    }
}
