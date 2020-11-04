//
//  xImageView.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit

open class xImageView: UIImageView {
    
    // MARK: - IBInspectable Property
    /// 圆角
    @IBInspectable public var cornerRadius : CGFloat = 0
    /// 是否为圆形图片(优先级高于圆角)
    @IBInspectable public var isCircle : Bool = false
    /// 默认填充色
    @IBInspectable public var defaultFillColor : UIColor = .clear
    
    // MARK: - Private Property
    /// 是否加载过样式
    private var isInitCompleted = false
    /// 遮罩(考虑到性能问题，这边使用遮罩来实现圆角
    private let maskLayer = CAShapeLayer()
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initCompleted()
    }
    required public init?(coder aDecoder: NSCoder) {
        // 没有指定构造器时，需要实现NSCoding的指定构造器
        super.init(coder: aDecoder)
        // 如果没有实现awakeFromNib，则会调用该方法
        self.initCompleted()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCompleted()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.maskLayer.frame = self.bounds
    }
    
    // MARK: - Open Func
    /// 视图已加载
    open func viewDidLoad() {
        self.maskLayer.backgroundColor = UIColor.clear.cgColor
        self.maskLayer.fillColor = UIColor.red.cgColor
        self.maskLayer.lineWidth = 1
        self.maskLayer.lineCap = .round
        self.maskLayer.lineJoin = .round
        self.contentMode = .scaleAspectFill // 全填充
        let size = self.bounds.size
        if self.defaultFillColor == .clear {
            self.image = UIColor.xNewRandom(alpha: 0.3).xToImage(size: size)
        }
        else {
            self.image = self.defaultFillColor.xToImage(size: size)
        }
    }
    /// 视图已显示（GCD调用）
    open func viewDidAppear() {
        let radius = self.isCircle ? self.bounds.width / 2 : self.cornerRadius
        self.clip(cornerRadius: radius)
    }
    
    // MARK: - Public Func
    /// 规则圆角
    public func clip(cornerRadius : CGFloat)
    {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.mask = nil
    }
    /// 不规则圆角
    public func clip(tlRadius : CGFloat,
                     trRadius : CGFloat,
                     blRadius : CGFloat,
                     brRadius : CGFloat)
    {
        self.layer.cornerRadius = 0
        self.layer.mask = nil
        guard tlRadius >= 0, trRadius >= 0, blRadius >= 0, brRadius >= 0 else { return }
        // 声明计算参数
        self.layoutIfNeeded()
        let frame = self.bounds
        // 开始绘制
        let path = UIBezierPath.xNew(rect: frame,
                                     tlRadius: tlRadius,
                                     trRadius: trRadius,
                                     blRadius: blRadius,
                                     brRadius: brRadius)
        // 添加遮罩(限制显示区域)
        self.maskLayer.frame = frame
        self.maskLayer.path = path.cgPath
        self.layer.mask = self.maskLayer
    }
    
    // MARK: - Private Func
    /// 设置内容UI
    private func initCompleted()
    {
        // 添加锁,防止重复加载
        objc_sync_enter(self)
        guard self.isInitCompleted == false else { return }
        
        self.viewDidLoad()
        DispatchQueue.main.async {
            self.viewDidAppear()
        }
        
        self.isInitCompleted = true
        objc_sync_exit(self)
    }
}
