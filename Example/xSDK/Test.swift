//
//  Test.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test: NSObject {

    /// 运行测试代码
    public static func run()
    {
        let a = "Hello Apple"
        xLog("MD51 = " + a.xToMD5String())
        xLog("MD52 = " + a.xToMD5String(salt: "bc"))
        xLog("SHA256 = " + a.xToSHAString(type: .SHA256))
        xLog("HMAC+SHA512 = " + a.xToHMACString(type: .SHA512, key: "abc"))
        
        let base64En = a.xToBase64EncodingString() ?? ""
        xLog("Base64 EN = " + base64En)
        let base64De = base64En.xToBase64DecodingString() ?? ""
        xLog("Base64 DE = " + base64De)
   
    }
}
