//
//  Kit10ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit10ViewController: xViewController {

    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var skuView: xSKUView!
    @IBOutlet weak var skuViewHeightLayout: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
        self.skuView.layer.borderWidth = 1
        self.skuView.layer.borderColor = UIColor.red.cgColor
        
        
        let config = xSKUConfig()
        config.borderWidth = 1
        config.cornerRadius = 4
        config.itemHeight = 30
        config.columnSpacing = 8
        config.rowSpacing = 5
        config.itemNormalBackgroundColor = .white
        config.itemChooseBackgroundColor = .orange
        config.itemChooseBorderColor = UIColor.orange
        self.skuView.config = config
    }
    override func addKit() {
        let arr = ["🍏🍎🍐🍊", "🍋", "🍌🍉🍇", "🍅🥑🥝🍍", "🍑🍒🍈", "🍓🍆🥒🥕🌶🥔🌽", "🍠🥜🥞🥓", "🥚🧀🥖🍞🥐", "🍯🍗🍖🍤", "🍳🍔🍟🌭🍕", "🍣🍥🥗", "🍲🍜🌯🌮", "🍝🍱🍛🍙🍚", "🍢🍡🍧🍫🍭🍬", "🍮🎂🍰🍦🍨🍿🍩🍪🥛", "🍺🍻🍷", "🍸🍽🍴", "🍼☕️🍵🍶🍾", "🍹🥙🥘🥂🥂🥃🥄🥥", "🥦🥨🥣🥤🥧🥠", "🥟🥫🥪🥩", "🥡🥢🥭🥬🥯🦴", "🥮🧁🧂"]
        self.skuView.reload(dataArray: arr, column: 0, completed: {
            [unowned self] (frame) in
            xLog(frame)
            // 刷新高度
            self.skuViewHeightLayout.constant = frame.height
            self.view.layoutIfNeeded()
            
        }, choose: {
            [unowned self] (idx) in
            self.resultLbl.text = arr[idx]
        })
    }

}
