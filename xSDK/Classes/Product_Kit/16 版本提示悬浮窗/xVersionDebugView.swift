//
//  xVersionDebugView.swift
//  xSDK
//
//  Created by Mac on 2020/10/27.
//

import UIKit

public class xVersionDebugView: UIView {
    
    // MARK: - IBOutlet Property
    /// 圆角容器
    @IBOutlet weak var container: xRoundCornerView!
    /// 版本
    @IBOutlet weak var versioinLbl: UILabel!
    /// 其他
    @IBOutlet weak var otherLbl: UILabel!
    
    // MARK: - Public Property
    /// 单例
    public static let shared = xVersionDebugView.loadNib()
    
    // MARK: - Public Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.container.isUserInteractionEnabled = false
        self.container.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.versioinLbl.text = "version \(xAppManager.shared.appVersion)"
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1  // 设置长按最低时间条件（这里长按至少1s）
        self.addGestureRecognizer(longPress)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let spv = self.superview else { return }
        let minY = xStatusHeight + xNavigationBarHeight + self.bounds.height / 2
        let maxY = xScreenHeight - xTabbarHeight - self.bounds.height / 2
        let pos = touch.location(in: spv)
        var y = pos.y
        if y < minY { y = minY }
        if y > maxY { y = maxY }
        self.center = .init(x: self.center.x,
                            y: y)
    }
    
    // MARK: - Public Func
    /// 显示
    public static func show(des: String)
    {
        guard let win = xKeyWindow else { return }
        // 更新UI
        shared.otherLbl.text = des
        if des.count == 0 {
            shared.otherLbl.text = "长按可截图"
        }
        // 添加悬浮窗
        shared.removeFromSuperview()
        win.addSubview(shared)
        // 更新位置信息
        shared.layoutIfNeeded()
        let w = shared.container.bounds.width
        //let h = shared.container.bounds.height
        shared.frame = .init(origin: .zero,
                             size: shared.container.bounds.size)
        shared.center = .init(x: xScreenWidth - w / 2,
                              y: xScreenHeight / 2)
    }
    /// 隐藏
    public static func hidden()
    {
        shared.removeFromSuperview()
    }
    
    // MARK: - Private Func
    /// 加载视图
    private class func loadNib() -> xVersionDebugView {
        let bundle = Bundle.init(for: self.classForCoder())
        let arr = bundle.loadNibNamed("xVersionDebugView", owner: nil, options: nil)!
        let view = arr.first! as! xVersionDebugView
        return view
    }
    /// 长按时间
    @objc private func longPress(gesture : UILongPressGestureRecognizer)
    {
        // 其他状态不管了
        guard gesture.state == .began else { return }
        xLog("长按")
//        guard let win = xKeyWindow else { return }
//        let img = win.xSnapshotImage()
//        xImageManager.saveImageToAlbum(img) {
//            (isSuccess) in
//            
//        }
    }
}
