//
//  xAppManager+Device.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit
import AdSupport

extension xAppManager {

    // MARK: - Public Func
    /// UUID
    public static func UUID() -> String
    {
        let ret = NSUUID.init().uuidString
        return ret
    }
    
    /// IDFA
    public static func IDFA() -> String
    {
        let ret = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return ret
    }
}
