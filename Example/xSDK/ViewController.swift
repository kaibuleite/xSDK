//
//  ViewController.swift
//  xSDK
//
//  Created by 177955297@qq.com on 09/14/2020.
//  Copyright (c) 2020 177955297@qq.com. All rights reserved.
//

import UIKit
import xSDK

// MARK: - Enum
// MARK: - Handler

// MARK: - IBOutlet Property
// MARK: - IBInspectable Property

// MARK: - Open Property
// MARK: - Public Property
// MARK: - Private Property

// MARK: - Open Override Func
// MARK: - Public Override Func
// MARK: - Open Func
// MARK: - Public Func
// MARK: - Private Func

// 组件化：https://www.jianshu.com/p/b075c34e2349
class ViewController: UITableViewController {

    /// 是否是测试视图
    @IBInspectable var isKit : Bool = false
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 获取类名
        let row = indexPath.row
        let name = String.init(format: "xSDK_Example.\(self.isKit ? "Kit" : "Test")%02dViewController", row)
        guard let xclass = NSClassFromString(name) else { return }
        guard let vcclass = xclass as? UIViewController.Type else { return }
        // 初始化控制器
        let vc = vcclass.init()
        let cell = tableView.cellForRow(at: indexPath)
        vc.title = cell?.textLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
