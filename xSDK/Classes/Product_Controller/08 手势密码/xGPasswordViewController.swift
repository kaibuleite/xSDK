//
//  xGPasswordViewController.swift
//  xSDK
//
//  Created by Mac on 2020/10/6.
//

import UIKit

public class xGPasswordViewController: xViewController {

    // MARK: - Handler
    /// 输入手势密码完成回调
    public typealias xHandlerInputGPassword = (String) -> Void
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var resultView: xGPasswordResultView!
    @IBOutlet weak var p1View: xGPasswordPointView!
    @IBOutlet weak var p2View: xGPasswordPointView!
    @IBOutlet weak var p3View: xGPasswordPointView!
    @IBOutlet weak var p4View: xGPasswordPointView!
    @IBOutlet weak var p5View: xGPasswordPointView!
    @IBOutlet weak var p6View: xGPasswordPointView!
    @IBOutlet weak var p7View: xGPasswordPointView!
    @IBOutlet weak var p8View: xGPasswordPointView!
    @IBOutlet weak var p9View: xGPasswordPointView!
    
    // MARK: - Public Property
    /// 密码最小长度
    public var passwordMinLength = 4
    /// 线配置
    public var lineConfig = xGPasswordLineConfig()
    /// 结果配置
    public var resultConfig = xGPasswordResultConfig()
    /// 点配置
    public var pointConfig = xGPasswordPointConfig()
    
    // MARK: - Private Property
    /// 输入完成回调
    private var inputHandler : xHandlerInputGPassword?
    /// 点视图数组
    private var pointViewArray = [xGPasswordPointView]()
    /// 选中的点视图数组
    private var choosePointViewArray = [xGPasswordPointView]()
    /// 线
    private let lineLayer = CAShapeLayer()
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xGPasswordViewController.xNew(storyboard: "xGPasswordViewController")
        return vc as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.isRootParentViewController = true
        self.pointViewArray = [self.p1View, self.p2View, self.p3View,
                               self.p4View, self.p5View, self.p6View,
                               self.p7View, self.p8View, self.p9View]
        for (i, view) in self.pointViewArray.enumerated() {
            view.tag = i + 1
        }
        // 线
        self.lineLayer.fillColor = UIColor.clear.cgColor
        self.lineLayer.lineCap = .round
        self.lineLayer.lineJoin = .round
        self.view.layer.addSublayer(self.lineLayer)
        // 刷新配置
        self.refreshConfig()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lineLayer.frame = self.view.bounds
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 清除内容
        self.clearAll()
        // 刷新配置
        self.refreshConfig()
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        for view in self.pointViewArray {
            guard view.isChoose == false else { continue }
            let point = touch.location(in: view)
            var rect = view.bounds
            rect.origin.x = rect.width / 2 - view.config.outerRadius
            rect.origin.y = rect.height / 2 - view.config.outerRadius
            rect.size.width = view.config.outerRadius * 2
            rect.size.height = view.config.outerRadius * 2
            if rect.contains(point) {
                view.isChoose = true
                // 设置箭头
                if let last = self.choosePointViewArray.last {
                    last.addArrow(to: view)
                }
                self.choosePointViewArray.append(view)
            }
        }
        let point = touch.location(in: self.view)
        self.drawingLine(end: point)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawEndLine()
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawEndLine()
    }
    
    // MARK: - IBOutlet Func
    @IBAction func closeBtnClick()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Public Func
    /// 添加输入回调
    public func addInputCompleted(_ handler : @escaping xHandlerInputGPassword)
    {
        self.inputHandler = handler
    }
    /// 清空状态
    public func clearAll()
    {
        self.choosePointViewArray.forEach {
            (view) in
            view.isChoose = false
        }
        self.choosePointViewArray.removeAll()
        self.lineLayer.path = UIBezierPath().cgPath
        //self.resultView.setLine(with: "")
    }
    
    // MARK: - Private Func
    /// 刷新配置
    private func refreshConfig()
    {
        self.lineLayer.lineWidth = self.lineConfig.lineWidth
        self.lineLayer.strokeColor = self.lineConfig.lineColor.cgColor
        self.resultView.config = self.resultConfig
        self.pointViewArray.forEach {
            [unowned self] (view) in
            view.config = self.pointConfig
        }
    }
    
    /// 画线
    private func drawingLine(end lastPoint : CGPoint)
    {
        let path = self.pointViewLinePath()
        guard path.isEmpty == false else { return }
        path.addLine(to: lastPoint)
        self.lineLayer.path = path.cgPath
    }
    
    /// 画线完成
    private func drawEndLine()
    {
        // 确定线条路径
        let path = self.pointViewLinePath()
        self.lineLayer.path = path.cgPath
        // 获取手势密码
        var gp = ""
        self.choosePointViewArray.forEach {
            (view) in
            gp += "\(view.tag)"
        }
        // 判断密码是否合法
        guard gp.count >= self.passwordMinLength else {
            xMessageAlert.display(message: "密码长度必须>=\(passwordMinLength)位")
            path.removeAllPoints()
            self.lineLayer.path = path.cgPath
            self.clearAll()
            return
        }
        // 回调
        self.resultView.setLine(with: gp)
        self.inputHandler?(gp)
    }
    
    /// 点视图上的线路径
    private func pointViewLinePath() -> UIBezierPath
    {
        let path = UIBezierPath.init()
        for view in self.choosePointViewArray {
            let x = view.bounds.width / 2
            let y = view.bounds.height / 2
            let center = CGPoint.init(x: x, y: y)
            let point = self.view.convert(center, from: view)
            if path.isEmpty {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        return path
    }
}
