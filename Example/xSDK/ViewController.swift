//
//  ViewController.swift
//  xSDK
//
//  Created by 177955297@qq.com on 09/14/2020.
//  Copyright (c) 2020 177955297@qq.com. All rights reserved.
//

import UIKit
import xSDK

class ViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc : UIViewController?
        switch indexPath.row {
        case 0:
            vc = Test01ViewController.init()
        default:
            break
        }
        guard let obj = vc else { return }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

