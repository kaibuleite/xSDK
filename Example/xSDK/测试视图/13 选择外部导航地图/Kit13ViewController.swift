//
//  Kit13ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/10/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK
import MapKit

class Kit13ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func chooseBtnClick() {
        let name = "测试地址"
        let lat = Double(24.871902)
        let lng = Double(118.550833)
        let coor = CLLocationCoordinate2D.init(latitude: lat,
                                               longitude: lng)
        xChooseNavigationMapActionSheet.display(from: self,
                                                targetName: name,
                                                targetCoordinate: coor)
    }
}
