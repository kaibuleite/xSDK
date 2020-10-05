//
//  Kit06ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit06ViewController: UIViewController {
    
    @IBOutlet weak var normalInput: xTextField!
    @IBOutlet weak var numberInput: xTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.normalInput.addBeginEditHandler {
            xLog("开始输入")
        }
        self.normalInput.addEditingHandler {
            (txt) in
            
        }
        self.normalInput.addReturnHandler {
            [weak self] in
            guard let ws = self else { return }
            ws.view.endEditing(true)
            xLog("完成、搜索。。。按钮")
        }
        self.normalInput.addEndEditHandler {
            xLog("结束输入")
        }
        
        self.numberInput.addEditingHandler {
            [weak self] (txt) in
            guard let ws = self else { return }
            let str = txt.xToInternationalNumberString()
            ws.numberInput.text = str
            // ws.numberInput.reset(text: str)
        }
        
        let inputArr = [self.normalInput,
                        self.numberInput]
        xTextField.relateInput(list: inputArr)
    }

}
