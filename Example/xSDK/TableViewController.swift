//
//  TableViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
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
