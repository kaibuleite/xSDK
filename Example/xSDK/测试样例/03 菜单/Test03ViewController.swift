//
//  Test03ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Test03ViewController: xViewController {
    
    @IBOutlet weak var redContainer: xClearView!
    @IBOutlet weak var blueContainer: xClearView!
    @IBOutlet weak var greenContainer: xClearView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addSegment1()
        self.addSegment2()
        self.addSegment3()
    }
    // MARK: - 菜单1——默认
    public func addSegment1()
    {
        let config = xSegmentConfig()
        config.itemsMargin = 10
        config.itemSelectedTitleColor = .red
        let seg =  xSegmentViewController.quickInstancetype()
        seg.config = config
        let arr = ["苹果", "香蕉", "梨子", "芒果", "葡萄"]
        seg.reload(titleArray: arr, fontSize: 10) {
            (idx) in
            x_log(arr[idx])
        }
        self.addChild(seg, in: self.redContainer)
    }
    
    // MARK: - 菜单2——超长滚动
    public func addSegment2()
    {
        let config = xSegmentConfig()
        config.itemsMargin = 0
        config.itemSelectedTitleColor = .blue
        config.lineColor = .blue
        let seg =  xSegmentViewController.quickInstancetype()
        seg.config = config
        let arr = ["马铃薯", "菠菜", "西红柿", "茄子", "辣椒",
                   "黄瓜", "南瓜", "冬瓜", "秋葵", "花菜", "玉米",
                   "韭菜", "青菜", "萝卜", "芋头", "红薯", "青椒"]
        seg.reload(titleArray: arr, fontSize: 14) {
            (idx) in
            x_log(arr[idx])
        }
        self.addChild(seg, in: self.blueContainer)
        seg.choose(idx: 0)
    }
    
    // MARK: - 菜单3——自定义视图（宽度可以自己算）
    public func addSegment3()
    {
        let config = xSegmentConfig()
        config.itemsMargin = 5
        config.itemSelectedTitleColor = .green
        config.lineColor = .green
        let seg =  xSegmentViewController.quickInstancetype()
        seg.config = config
        let arr = ["🍏", "🍎", "🍐", "🍊", "🍆", "🍳",
                   "🍋", "🥝", "🥑", "🥔", "🥒", "🥓",
                   "🍌", "🍒", "🍅", "🌽", "🍞", "🍖",
                   "🍇", "🍍", "🥐", "🍠", "🍕", "🍟",
                   "🍉", "🍑", "🌭", "🌶", "🧀", "🥞",
                   "🍓", "🍈", "🥜", "🥕", "🥖", "🥚", ]
        var viewArray = [UIView]()
        arr.forEach {
            (str) in
            let lbl = UILabel()
            lbl.text = str
            lbl.textAlignment = .center
            lbl.font = .systemFont(ofSize: 17)
            lbl.frame = .init(x: 0, y: 0, width: 30, height: 0)
            viewArray.append(lbl)
        }
        seg.reload(itemViewArray: viewArray) {
            (idx) in
            x_log(arr[idx])
        }
        self.addChild(seg, in: self.greenContainer)
        seg.choose(idx: 0)
    }
}
