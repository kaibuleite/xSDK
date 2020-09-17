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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc : UIViewController?
        switch indexPath.row {
        case 0:
            vc = Test01ViewController.init()
        case 1:
            vc = Test02ViewController.init()
        case 2:
            vc = Test03ViewController.init()
        default:
            break
        }
        guard let obj = vc else { return }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

class tv : xViewController {
    
    override func addKit() {
    }
}
