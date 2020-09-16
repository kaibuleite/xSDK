//
//  Test01ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/15.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test01ViewController: UIViewController {
 
    @IBAction func defaultBtnClick() {
        let config = xRequestMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .indicator
        xRequestMaskViewController.shared.config = config
        xRequestMaskViewController.display()
    }
    @IBAction func anime1BtnClick() {
        let config = xRequestMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .lineJump
        xRequestMaskViewController.shared.config = config
        xRequestMaskViewController.display()
    }
    @IBAction func anime2BtnClick() {
        let config = xRequestMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .eatBeans
        xRequestMaskViewController.shared.config = config
        xRequestMaskViewController.display()
    }
    @IBAction func anime3BtnClick() {
        let config = xRequestMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .magic1
        xRequestMaskViewController.shared.config = config
        xRequestMaskViewController.display()
    }
    @IBAction func anime4BtnClick() {
        let config = xRequestMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .magic2
        xRequestMaskViewController.shared.config = config
        xRequestMaskViewController.display()
    }
    
    
}
