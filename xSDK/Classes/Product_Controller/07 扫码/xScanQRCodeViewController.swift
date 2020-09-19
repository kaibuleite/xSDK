//
//  xScanQRCodeViewController.swift
//  xSDK
//
//  Created by Mac on 2020/9/19.
//

import UIKit
import AVKit

public class xScanQRCodeViewController: xViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Handler
    /// 扫描完成回调
    public typealias xHandlerScanCode = (String) -> Void
    
    // MARK: - IBOutlet Property
    /// 扫描视图
    @IBOutlet weak var scanView: xClearView!
    /// 扫描线
    @IBOutlet weak var scanLine: UIImageView!
    /// 扫描线顶部约束
    @IBOutlet weak var scanLineTopLayout: NSLayoutConstraint!
    
    // MARK: - Private Property
    /// 扫描完成回调
    private var handler : xHandlerScanCode?
    
    /// 会话层对象,数据交互
    private var session : AVCaptureSession = AVCaptureSession()
    /// 边框图层
    private var borderLayer = CAShapeLayer()
    /// 定位描边图层
    private var locateLayer = CAShapeLayer()
    /// 是否扫描成功（防止多次回调）
    private var isScanSuccess = false
    /// 输入对象,用来捕捉图像
    private var input : AVCaptureDeviceInput?
    /// 输出对象,用来处理图像
    private lazy var output : AVCaptureMetadataOutput =
    {
        /*  这里面涉及到二维码输出时的坐标转换即：x/y互换，
            宽高互换得出可以扫描的位置，超出部分则不进行扫描 */
        let out = AVCaptureMetadataOutput()
        let rect = UIScreen.main.bounds
        let scaneRect = self.scanView.frame
        
        let x = scaneRect.origin.y / rect.height
        let y = scaneRect.origin.x / rect.width
        let w = scaneRect.height / rect.height
        let h = scaneRect.width / rect.width
        
        out.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        return out
    }()
    /// 预览层,提供预览结果
    private lazy var previewLayer : AVCaptureVideoPreviewLayer =
    {
        let layer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        return layer
    }()
    
    // MARK: - 内存释放
    deinit {
        self.handler = nil
        if let input = self.input {
            self.session.removeInput(input)
        }
        self.input = nil
        self.session.removeOutput(self.output)
    }

    // MARK: - Public Override Func
    public override class func quickInstancetype() -> Self {
        let vc = xScanQRCodeViewController.new(storyboard: "xScanQRCodeViewController")
        return vc as! Self
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.scanLine.isHidden = true
        // 边框图层
        self.borderLayer.lineWidth = 3
        self.borderLayer.lineCap = .round
        self.borderLayer.lineJoin = .round
        self.borderLayer.backgroundColor = UIColor.clear.cgColor
        self.borderLayer.borderColor = UIColor.clear.cgColor
        self.borderLayer.fillColor = UIColor.clear.cgColor
        self.borderLayer.strokeColor = UIColor.x_hex("00C2FF").cgColor
        self.scanView.layer.addSublayer(self.borderLayer)
        // 定位图层
        self.locateLayer.borderWidth = 1
        self.locateLayer.fillColor = UIColor.clear.cgColor
        self.locateLayer.strokeColor = UIColor.orange.cgColor
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        xAppManager.closePhoneLight()
    }
    public override func addKit() {
        self.drawBorder()
        self.startScanAnime()
        self.startScanCodeCamera()
    }
    
    // MARK: - IBAction Func
    @IBAction func backBtnClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func albumBtnClick() {
        self.startScanCodeAlbum()
    }
    @IBAction func lightBtnClick(_ sender : UIButton) {
        var name = ""
        if sender.tag == 0 {
            sender.tag = 1
            name = "light_on"
            xAppManager.openPhoneLight()
        }
        else {
            sender.tag = 0
            name = "light_off"
            xAppManager.closePhoneLight()
        }
        let bundle = Bundle.init(for: self.classForCoder)
        let img = UIImage.init(named: name, in: bundle, compatibleWith: nil) 
        sender.setImage(img, for: .normal)
    }
    
    // MARK: - Public Func
    /// 显示扫码界面
    /// - Parameters:
    ///   - parent: 父视图控制器
    ///   - animated: 是否执行动画
    ///   - handler: 回调
    public class func display(from viewController : UIViewController,
                              animated : Bool = true,
                              handler : @escaping xHandlerScanCode)
    {
        let vc = xScanQRCodeViewController.quickInstancetype()
        // 设置回调
        vc.handler = handler
        viewController.present(vc, animated: true, completion: nil)
    }

    // MARK: - Private Func
    // TODO: 扫码操作
    /// 摄像头扫描二维码
    private func startScanCodeCamera() -> Void
    {
        // 对懒加载的input进行赋值
        guard let device = AVCaptureDevice.default(for: .video) else {
            x_warning("设备初始化失败")
            self.scanFailure()
            return
        }
        self.input = try? AVCaptureDeviceInput.init(device: device)
        // 1.判断是否能加入输入
        guard session.canAddInput(self.input!) else {
            x_warning("无法加入输入")
            self.scanFailure()
            return
        }
        // 2.判断是否能加入输出
        guard session.canAddOutput(self.output) else {
            x_warning("无法加入输出")
            self.scanFailure()
            return
        }
        // 3.加入输入和输出
        self.session.addInput(self.input!)
        self.session.addOutput(self.output)
        // 4.设置输出能够解析的数据类型
        self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes
        // 5.设置监听监听解析到的数据类型,并设置代理
        self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 6.添加预览图层
        self.previewLayer.frame = UIScreen.main.bounds
        self.view.layer.insertSublayer(previewLayer, at: 0)
        // 7.开始扫描
        self.session.startRunning()
    }
    /// 二维码扫描(本地相册)
    private func startScanCodeAlbum() -> Void
    {
        let picker = xImagePickerController.init()
        picker.displayPhotoLibrary(from: self) {
            [weak self] (image) in
            guard let ws = self else { return }
            // 识别图片
            guard let ciimage = image.ciImage else {
                x_warning("图片转换失败")
                ws.scanFailure()
                return
            }
            // 创建探测器,检测精度设高一点
            let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
            guard let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: options) else {
                x_warning("探测器创建失败")
                ws.scanFailure()
                return
            }
            let results : [CIFeature] = detector.features(in: ciimage)
            for result in results {
                guard let obj = result as? CIQRCodeFeature else { continue }
                if let code = obj.messageString {
                    ws.scanSuccess(code: code)
                    return
                }
            }
            ws.scanFailure()
        }
    }
    
    // TODO: 绘制UI
    /// 开始扫描动画
    private func startScanAnime()
    {
        let h = 2 * self.scanLine.bounds.height
        self.scanLineTopLayout.constant = -h
        self.view.layoutIfNeeded()
        self.scanLine.isHidden = false
        UIView.animate(withDuration: 3, animations: {
            self.scanLineTopLayout.constant = self.scanView.bounds.height + h
            self.view.layoutIfNeeded()
            
        }, completion: {
            [weak self] (finish) in
            guard let ws = self else { return }
            ws.startScanAnime() // 递归无线执行
        })
    }
    /// 绘制扫描边框
    private func drawBorder() -> Void
    {
        // 绘制边框
        self.view.layoutIfNeeded()
        var frame = self.scanView.bounds
        let lineWidth = self.borderLayer.lineWidth / 2
        frame.origin.x = lineWidth
        frame.origin.y = lineWidth
        frame.size.width -= 2 * lineWidth
        frame.size.height -= 2 * lineWidth
        self.borderLayer.frame = frame
        // 线条长度
        let l = CGFloat(50)
        let w = frame.width
        let h = frame.height
        let path = UIBezierPath.init()
        // 左上角
        path.move(to: .init(x: 0, y: l))
        path.addLine(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: l, y: 0))
        // 右上角
        path.move(to: .init(x: w - l, y: 0))
        path.addLine(to: .init(x: w, y: 0))
        path.addLine(to: .init(x: w, y: l))
        // 右下角
        path.move(to: .init(x: w, y: h - l))
        path.addLine(to: .init(x: w, y: h))
        path.addLine(to: .init(x: w - l, y: h))
        // 左下角
        path.move(to: .init(x: l, y: h))
        path.addLine(to: .init(x: 0, y: h))
        path.addLine(to: .init(x: 0, y: h - l))
        self.borderLayer.path = path.cgPath
    }
    /// 定位到扫描的二维码，对扫描到的二维码进行描边
    private func drawLocate(object : AVMetadataMachineReadableCodeObject)
    {
        let array = object.corners
        x_log("定位到二维码 \(array)")
        guard array.count > 0 else { return }
        let path = UIBezierPath()
        var index = 0
        while index < array.count {
            let point = array[index]
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
            index += 1
        }
        path.close()
        self.locateLayer.path = path.cgPath
        self.locateLayer.frame = self.previewLayer.bounds
        self.previewLayer.addSublayer(self.locateLayer)
    }
    
    // TODO: 扫描结果
    /// 扫描成功
    private func scanSuccess(code : String) -> Void
    {
        x_log("扫描成功 : " + code)
        self.isScanSuccess = true
        // 播放音效
        xAppManager.playSound(name: "scan_success", id: 50923)
        // 执行回调
        self.handler?(code)
        self.backBtnClick()
    }
    /// 扫描失败
    private func scanFailure() -> Void
    {
        x_alert(message: "扫描失败")
        self.isScanSuccess = false
        self.handler = nil
        self.backBtnClick()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection)
    {
        guard let obj = metadataObjects.last else { return }
        // 1.扫描到东西
        let code : String? = (obj as AnyObject).stringValue
        if let str = code {
            guard self.isScanSuccess == false else { return }
            self.scanSuccess(code: str)
            return
        }
        // 2.清除之前画的图层
        self.locateLayer.removeFromSuperlayer()
        // 3.对扫描到的二维码进行描边
        /*
        guard let codeObj = self.previewLayer.transformedMetadataObject(for: obj) as? AVMetadataMachineReadableCodeObject else { return }
        self.drawLocate(object: codeObj) */
    }
}
