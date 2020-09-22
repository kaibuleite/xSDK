//
//  Kit12ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit12ViewController: UIViewController {

    @IBOutlet weak var page: xPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.page.backgroundColor = .groupTableViewBackground
        self.page.pagesCount = 10
        self.page.currentPage = 5
    }
    @IBAction func previousBtnClick() {
        guard self.page.currentPage > 0 else { return }
        self.page.currentPage -= 1
    }
    @IBAction func nextBtnClick() {
        guard self.page.currentPage < 9 else { return }
        self.page.currentPage += 1
    }
    
}
