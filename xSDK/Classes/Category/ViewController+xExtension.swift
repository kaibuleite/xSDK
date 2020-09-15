//
//  ViewController+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension UIViewController {

    // MARK: - 实例化对象
    /// 通过storyboard实例化
    open class func new(storyboard name : String,
                        identifier : String = "") -> Self?
    {
        let bundle = Bundle.init(for: self.classForCoder())
        let sb = UIStoryboard.init(name: name, bundle: bundle)
        if identifier == "" {
            let vc = sb.instantiateInitialViewController()
            return vc as? Self
        }
        else {
            let vc = sb.instantiateViewController(withIdentifier: identifier)
            return vc as? Self
        }
        
    }
}
