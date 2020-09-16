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
        let config = xMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .indicator
        xMaskViewController.shared.config = config
        xMaskViewController.display()
    }
    @IBAction func anime1BtnClick() {
        let config = xMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .lineJump
        xMaskViewController.shared.config = config
        xMaskViewController.display()
    }
    @IBAction func anime2BtnClick() {
        let config = xMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .eatBeans
        xMaskViewController.shared.config = config
        xMaskViewController.display()
    }
    @IBAction func anime3BtnClick() {
        let config = xMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .magic1
        xMaskViewController.shared.config = config
        xMaskViewController.display()
    }
    @IBAction func anime4BtnClick() {
        let config = xMaskConfig()
        config.bgStyle = .gray
        config.flagStyle = .anime
        config.animeStyle = .magic2
        xMaskViewController.shared.config = config
        xMaskViewController.display()
    }
    
}
