//
//  Kit14ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/14.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit14ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    // MARK: - Public Func
    /// 安全
    @IBAction func safeBtnClick()
    {
        let list = xAnimation.xAnimationTypeEnum.safeTypeList()
        let idx = arc4random() % UInt32(list.count)
        let anim = list[Int(idx)]
        self.start(animType: anim)
    }
    /// 不安全
    @IBAction func unsafeBtnClick()
    {
        xMessageAlert.display(message: "容易崩溃，暂时不启用")
//        return
        /*
         */
        let list = xAnimation.xAnimationTypeEnum.unsafeTypeList()
        let idx = arc4random() % UInt32(list.count)
        let anim = list[Int(idx)]
        self.start(animType: anim)
    }   
    
    func start(animType : xAnimation.xAnimationTypeEnum)
    {
        let anime = xAnimation.new(type: animType, subtype: .fromLeft, duration: 1, timing: .easeInEaseOut)
        xLog("动画类型：\(animType)")
        self.view.layer.add(anime, forKey: "xxx")
        self.view.backgroundColor = UIColor.xNewRandom(alpha: 0.5)
    }
}
