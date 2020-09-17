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
        let row = indexPath.row
        guard let vc = self.isKit ? self.kit(row: row) : self.test(row: row) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 测试样例
    public func test(row : Int) -> UIViewController?
    {
        switch row {
        case 1:
            return Test01ViewController.init()
        case 2:
            return Test02ViewController.init()
        case 3:
            return Test03ViewController.init()
        default:
            return nil
        }
    }
    
    // MARK: - 测试视图
    public func kit(row : Int) -> UIViewController?
    {
        switch row {
        case 1:
            return Kit01ViewController.init()
        case 2:
            return Kit02ViewController.init()
        case 3:
            return Kit03ViewController.init()
        default:
            return nil
        }
    }
}
