//
//  ViewController+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/9/15.
//

import UIKit

extension UIViewController {
    
    // MARK: - Objc Open Func
    /// 添加其他UI控件
    @objc open func addKit() { }
    /// 添加子控制器
    @objc open func addChildren() { }
    /// 快速实例化对象(storyboard比类名少指定后缀)
    @objc open class func quickInstancetype() -> Self
    {
        let vc = self.init()
        return vc
    }
    /// 请求数据
    @objc open func requestData() { }
    
    // MARK: - Public Func
    /// 通过storyboard实例化
    /// - Parameters:
    ///   - name: storyboard名称，传nil则跟当前类相同名称
    ///   - identifier: 身份标识
    /// - Returns: 实例化对象
    public class func xNew(storyboard name : String?,
                           identifier : String = "") -> Self
    {
        let bundle = Bundle.init(for: self.classForCoder())
        var str = name ?? ""
        if str.count == 0 {
            str = self.xClassStruct.name
        }
        let sb = UIStoryboard.init(name: str, bundle: bundle)
        if identifier.count == 0 {
            let vc = sb.instantiateInitialViewController()
            return vc as! Self
        }
        else {
            let vc = sb.instantiateViewController(withIdentifier: identifier)
            return vc as! Self
        }
    }
    
    /// 添加子控制器
    /// - Parameters:
    ///   - vc: 添加子控制器
    ///   - container: 容器
    ///   - frame: frame
    /// - Returns: 添加结果
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
    
    /// 设置Tabbar默认标题颜色
    /// - Parameter color: 指定颜色
    public func setTabbarItemNormalTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        self.tabBarItem.setTitleTextAttributes(attr, for: .normal)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let normal = appearance.stackedLayoutAppearance.normal
            normal.titleTextAttributes = attr
            self.tabBarItem.standardAppearance = appearance
        }
    }
    
    /// 设置Tabbar选中标题颜色
    /// - Parameter color: 指定颜色
    public func setTabbarItemSelectedTitleColor(_ color : UIColor)
    {
        let attr = [NSAttributedString.Key.foregroundColor : color]
        self.tabBarItem.setTitleTextAttributes(attr, for: .selected)
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance.init()
            let selected = appearance.stackedLayoutAppearance.selected
            selected.titleTextAttributes = attr
            self.tabBarItem.standardAppearance = appearance
        }
    }
}
