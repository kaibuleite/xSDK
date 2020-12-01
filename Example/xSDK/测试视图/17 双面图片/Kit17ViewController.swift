//
//  Kit17ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/12/1.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit17ViewController: UIViewController {

    @IBOutlet weak var icon: xTwoSideImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.icon.set(topImage: UIImage.init(named: "IMG_1"),
                      backImage: UIImage.init(named: "IMG_2"),
                      side: .top)
    }

    
    @IBAction func chooseBtnClick() {
        self.icon.flip()
    }

}
