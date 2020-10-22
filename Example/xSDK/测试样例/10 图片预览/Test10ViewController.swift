//
//  Test10ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test10ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func normalBtnClick() {
        
        var arr = [UIImage]()
        for i in 0 ... 9 {
            let name = "IMG_\(i)"
            guard let img = UIImage.init(named: name) else { continue }
            arr.append(img)
        }
        guard arr.count > 0 else { return }
        xPreviewImagesViewController.display(from: self, images: arr, index: 0)
    }
    
    @IBAction func gifBtnClick() {
        var arr = [UIImage]()
        for i in 0 ... 5 {
            let name = "PIC_\(i)"
            let path = Bundle.main.path(forResource: name, ofType: ".gif")
            let data = NSData.init(contentsOf: <#T##URL#>)
            guard let img = UIImage.init(named: name) else { continue }
            arr.append(img)
        }
        guard arr.count > 0 else { return }
        xPreviewImagesViewController.display(from: self, images: arr, index: 0)
    }

}
