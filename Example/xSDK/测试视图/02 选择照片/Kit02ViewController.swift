//
//  Kit02ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit02ViewController: UIViewController {

    @IBOutlet weak var photoIcon: UIImageView!
    
    @IBAction func chooseBtnClick() {
        xChoosePhotoActionSheet.display(from: self, allowsEditing: true) {
            [weak self] (image) in
            guard let ws = self else { return }
            ws.photoIcon.image = image
        }
    }
}
