//
//  Test09ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test09ViewController: UIViewController {

    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var icon6: UIImageView!
    @IBOutlet weak var icon7: UIImageView!
    @IBOutlet weak var icon8: UIImageView!
    @IBOutlet weak var icon9: UIImageView!
    
    var iconArray = [UIImageView]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.iconArray = [self.icon1, self.icon2, self.icon3,
                          self.icon4, self.icon5, self.icon6,
                          self.icon7, self.icon8, self.icon9]
        self.iconArray.forEach {
            (icon) in
            icon.image = xAppManager.shared.placeholderImage
            icon.contentMode = .scaleAspectFill
        }
    }
 
    @IBAction func chooseBtnClick() {
        xChooseAlbumPhotosViewController.display(from: self, maxImagesCount: 9) {
            [unowned self] (imageList, assetList) in
            for (i, icon) in self.iconArray.enumerated()
            {
                if i < imageList.count {
                    icon.image = imageList[i]
                }
                else {
                    icon.image = xAppManager.shared.placeholderImage
                }
            }
        }
    }
    
}
