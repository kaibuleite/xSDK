//
//  Kit03ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit03ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let view = xDataEmptyView.loadNib()
        view.frame = self.view.bounds
        self.view.addSubview(view)
    }

}
