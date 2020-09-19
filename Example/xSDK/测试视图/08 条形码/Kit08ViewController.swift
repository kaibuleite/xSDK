//
//  Kit08ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit08ViewController: xViewController {
    
    @IBOutlet weak var code1View: xEANCodeImageView!
    @IBOutlet weak var code2View: xEANCodeImageView!
    @IBOutlet weak var code3View: xEANCodeImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func addKit() {
        self.code1View.set(code: "125469452")
        self.code2View.set(code: "12354123112")
        self.code3View.set(code: "1546262656565")
    }
 
}
