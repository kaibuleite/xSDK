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
    public typealias xHandlerInputGPassword = (xGPasswordViewController, String) -> Void
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var closeBtn: UIButton!
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
    
    // MARK: - IBInspectable Property
    /// 是否显示关闭按钮
    @IBInspectable public var isShowCloseBtn = true
    
    // MARK: - Public Property
    /// 点配置
    public var config = xGPasswordConfig()
    
    // MARK: - Private Property
    /// 点视图数组
    private var pointViewArray = [xGPasswordPointView]()
    /// 选中的点视图数组
    private var choosePointViewArray = [xGPasswordPointView]()
    /// 线
    private let lineLayer = CAShapeLayer()
    /// 输入完成回调
    private var inputHandler : xHandlerInputGPassword?
    
    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xGPasswordViewController.xNew(storyboard: "xGPasswordViewController")
        return vc as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.isRootParentViewController = true
        self.closeBtn.isHidden = !self.isShowCloseBtn
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
        self.dismiss()
    }
    
    // MARK: - Public Func
    /// 显示扫码界面
    /// - Parameters:
    ///   - parent: 父视图控制器
    ///   - animated: 是否执行动画
    ///   - handler: 回调
    public class func display(from viewController : UIViewController,
                              isShowCloseBtn : Bool = true,
                              config : xGPasswordConfig = .init(),
                              animated : Bool = true,
                              inputGPassword handler : @escaping xHandlerInputGPassword)
    {
        let vc = xGPasswordViewController.quickInstancetype()
        vc.isShowCloseBtn = isShowCloseBtn
        vc.config = config
        vc.inputHandler = handler
        viewController.present(vc, animated: true, completion: nil)
    }
    /// 关闭界面
    public func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
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
        self.lineLayer.lineWidth = self.config.lineConfig.lineWidth
        self.lineLayer.strokeColor = self.config.lineConfig.lineColor.cgColor
        self.resultView.config = self.config.resultConfig
        self.pointViewArray.forEach {
            [unowned self] (view) in
            view.config = self.config.pointConfig
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
        let maxLength = self.config.passwordMinLength
        guard gp.count >= maxLength else {
            xMessageAlert.display(message: "密码长度必须>=\(maxLength)位")
            path.removeAllPoints()
            self.lineLayer.path = path.cgPath
            self.clearAll()
            return
        }
        // 回调
        if self.config.isAutoClearLine {
            self.clearAll()
        }
        self.resultView.setLine(with: gp)
        self.inputHandler?(self, gp)
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
