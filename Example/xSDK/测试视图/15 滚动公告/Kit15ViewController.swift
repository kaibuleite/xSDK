//
//  Kit15ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/15.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit15ViewController: xViewController {

    @IBOutlet weak var sn1: xNoticeScrollView!
    @IBOutlet weak var sn2: xNoticeScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addKit() {
        self.sn1.backgroundColor = .xNewRandom(alpha: 0.5)
        self.sn2.backgroundColor = .xNewRandom(alpha: 0.5)
        
        let arr1 = ["🍏🍎🍐🍊🍋", "🍌🍉🍇🍅🥑🥝", "🍍🍑🍒🍈🍓🍆🥒", "🥕🌶🥔🌽", "🍠🥜🥞🥓🥚🧀", "🥖🍞🥐🍯🍗🍖🍤", "🍳🍔🍟🌭🍕🍣🍥🥗🍲", "🍜🌯🌮🍝🍱🍛🍙🍚", "🍘🍢🍡🍧🍫🍭🍬🍮🎂🍰", "🍦🍨🍿🍩🍪🥛🍺🍻", "🍷🍸🍽🍴🍼☕️🍵🍶🍾🍹"]
        self.sn1.scrollDirection = .vertical
        self.sn1.textFontSize = 13
        self.sn1.reload(dataArray: arr1) {
            xLog("公告1加载完成")
            
        } choose: {
            (title) in
            xLog("点击公告1:\(title)")
        }
        
        
        let arr2 = ["111111111111111", "22222", "333333333333", "4444444444444444444444444444444444444444444", "5555555555555", "6666"]
        self.sn2.scrollDirection = .horizontal
        self.sn2.stopDuration = 1
        self.sn2.textFontSize = 18
        self.sn2.reload(dataArray: arr2) { 
            xLog("公告2加载完成")
            
        } choose: {
            (title) in
            xLog("点击公告2:\(title)")
        }
    }
}
