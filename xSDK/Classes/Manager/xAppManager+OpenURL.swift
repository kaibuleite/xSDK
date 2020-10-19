//
//  xAppManager+OpenURL.swift
//  xSDK
//
//  Created by Mac on 2020/10/14.
//

import UIKit

extension xAppManager {
    
    // MARK: - Public Func
    /// 拨打电话
    public static func open(phone : String)
    {
        let str = "tel://" + phone
        guard let url = str.xToURL() else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.openURL(url)
    }
    
}
