//
//  Kit11ViewController.swift
//  xSDK_Example
//
//  Created by Mac on 2020/9/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import xSDK

class Kit11ViewController: xViewController {
    
    @IBOutlet weak var seg1: xSegmentView!
    @IBOutlet weak var seg2: xSegmentView!
    @IBOutlet weak var seg3: xSegmentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .groupTableViewBackground
    }
    override func addKit() {
        self.addSegment1()
        self.addSegment2()
        self.addSegment3()
    }
    // MARK: - 菜单1——默认
    public func addSegment1()
    {
        let config = xSegmentConfig()
        config.spacing = 5
        config.titleColor.normal = .green
        config.titleColor.choose = .red
        config.line.widthOfItemPercent = 0.5
        self.seg1.config = config
        let arr = ["苹果", "香蕉", "梨子", "芒果", "葡萄"]
        self.seg1.reload(titleArray: arr, fillMode: .fillEqually, fontSize: 10) {
            (idx) in
            xLog(arr[idx])
        }
    }
    
    // MARK: - 菜单2——超长滚动
    public func addSegment2()
    {
        let config = xSegmentConfig()
        config.spacing = 10
        config.titleColor.choose = .blue
        config.line.color = .orange
        config.border.width = 1
        config.border.color.choose = .blue
        self.seg2.config = config
        let arr = ["马铃薯", "菠菜", "西红柿", "茄子", "辣椒",
                   "黄瓜", "南瓜", "冬瓜", "秋葵", "花菜", "玉米",
                   "韭菜", "青菜", "萝卜", "芋头", "红薯", "青椒"]
        self.seg2.reload(titleArray: arr, fillMode: .auto, fontSize: 14) {
            (idx) in
            xLog(arr[idx])
        }
        self.seg2.choose(idx: 0)
    }
    
    // MARK: - 菜单3——自定义视图（宽度可以自己算）
    public func addSegment3()
    {
        let config = xSegmentConfig()
        config.spacing = 5
        config.line.color = .purple
        self.seg3.config = config
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
            // 指定宽度
            lbl.frame = .init(x: 0, y: 0, width: 30, height: 30)
            viewArray.append(lbl)
        }
        self.seg3.reload(itemViewArray: viewArray) {
            (idx) in
            xLog(arr[idx])
        }
        self.seg3.choose(idx: 2)
    }

}
