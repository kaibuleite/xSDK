//
//  Test07ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test07ViewController: UIViewController {

    @IBOutlet weak var resultLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func scanBtnClick() {
        xScanQRCodeViewController.display(from: self) {
            [unowned self] (code) in
            self.resultLbl.text = code
        }
    }
    
}
