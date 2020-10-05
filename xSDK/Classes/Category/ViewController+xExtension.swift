//
//  ViewController+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension UIViewController {
    
    // MARK: - Public Func
    // TODO: 实例化对象
    /// 通过storyboard实例化
    public class func xNew(storyboard name : String,
                          identifier : String = "") -> Self
    {
        let bundle = Bundle.init(for: self.classForCoder())
        let sb = UIStoryboard.init(name: name, bundle: bundle)
        if identifier == "" {
            let vc = sb.instantiateInitialViewController()
            return vc as! Self
        }
        else {
            let vc = sb.instantiateViewController(withIdentifier: identifier)
            return vc as! Self
        }
    }
    
}

extension xViewController {
    
    // MARK: - Public Func
    // TODO: - 添加子控制器
    /// 添加子控制器
    @discardableResult
    public func xAddChild(_ vc : UIViewController?,
                          in container : UIView?,
                          frame : CGRect = .zero) -> Bool
    {
        guard let obj = vc else {
            xWarning("子控制器为nil")
            return false
        }
        guard let view = container else {
            xWarning("子控制器容器为nil")
            return false
        }
        self.addChild(obj)
        obj.view.frame = frame
        if frame == .zero {
            obj.view.frame = view.bounds
        }
        view.addSubview(obj.view)
        return true
    }
}
